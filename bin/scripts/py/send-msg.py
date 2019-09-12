#!/usr/bin/env python

"""
  @package: -
   @script: send-msg.py
  @purpose: IP Message Sender. Sends TCP/UDP messages (multi-threaded).
  @created: Aug 26, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
     @site: https://github.com/yorevs/homesetup
  @license: Please refer to <http://unlicense.org/>
"""

from time import sleep, time as time
from datetime import timedelta
from decimal import Decimal

import os
import sys
import socket
import getopt
import threading
import signal

PROC_NAME       = os.path.basename(__file__)
VERSION         = (1, 0, 1)
MIN_PYTHON      = (2, 6, 6)
MAX_PYTHON      = (2, 7, 15)
CUR_PYTHON      = sys.version_info
MAX_THREADS     = 1000
NET_TYPE_UDP    = 'UDP'
NET_TYPE_TCP    = 'TCP'

MAX_DISPLAYED_MSG_LEN = 500

USAGE = """
IP Message Sender v{}

Usage: {} [opts]

    Options:
        -m, --message    <message/filename> : The message to be sent. If the message matches a filename, then the
                                              file is read and the content sent instead.
        -p, --port       <port_num>         : The port number [1-65535] ( default is 12345).
        -a, --address    <host_address>     : The address of the datagram receiver ( default is 127.0.0.1 ).
        -k, --packets    <num_packets>      : The number of max datagrams to be send. If zero is specified, then the app
                                              is going to send indefinitely ( default is 100 ).
        -i, --interval   <interval_MS>      : The interval between each datagram ( default is 1 Second ).
        -t, --threads    <threads_num>      : Number of threads [1-{}] to be opened to send simultaneously ( default is 1 ).
        -n, --netType    <network_type>     : The network type to be used. Either UDP or TCP ( default is TCP ).
""".format(str(VERSION), PROC_NAME, MAX_THREADS)

# @purpose: Display the usage message and exit with the specified code ( or zero as default )
def usage(exitCode=0):
    print(USAGE)
    sys.exit(exitCode)

# @purpose: Display the current program version and exit
def version():
    print('{} v{}.{}.{}'.format(PROC_NAME,VERSION[0],VERSION[1],VERSION[2]))
    sys.exit(0)

class TcpUdpIpSender(object):

    def __init__(self, address, port, packets, interval, message, threads, netType):
        self.host = (address, port)
        self.packets = packets
        self.interval = interval
        self.message = message
        self.threads = threads
        self.isAlive = True
        self.netType = netType

        signal.signal(signal.SIGINT, self.__interrupt_handler__)
        signal.signal(signal.SIGTERM, self.__interrupt_handler__)

        self.__initSockets__()

    def __initSockets__(self):

        if self.netType == NET_TYPE_UDP:
            self.clientSocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        else:
            self.clientSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            try:
                self.clientSocket.connect(self.host)
            except socket.error as err:
                print('\n###Error -> {}'.format(str(err)))
                sys.exit(2)

    def __interrupt_handler__(self, sigNum, fraNum):
        print('Program has been interrupted [Ctrl+C] ^{}'.format(sigNum))
        print('Terminating threads')
        self.isAlive = False
        if self.netType == NET_TYPE_TCP:
            print('Closing TCP connection')
            self.clientSocket.close()

    def startSending(self):
        print('Start sending {} packets every {} seconds: max. of[{}] to {} \nTHREADS = {}'.format(
                self.netType
                ,self.interval
                ,self.packets
                ,self.host
                ,self.threads
            )
        )

        threadsNum = threading.active_count()

        for i in range(1, self.threads + 1):
            tr = threading.Thread(target=self.sendPacket, args=(i,))
            tr.setDaemon(True)
            tr.start()
            sleep(0.011)

        while self.isAlive and threading.active_count() > threadsNum:
            sleep(0.50)

    def sendPacket(self, i):
        counter=1
        lenMsg = len(self.message)

        while self.isAlive and self.packets <= 0 or counter <= self.packets:
            print('[Thread-%.2d] Sending [%d] bytes, Pkt = %d/%d ...' % (i, lenMsg, counter, self.packets))
            if self.netType == NET_TYPE_UDP:
                self.clientSocket.sendto(self.message, self.host)
            else:
                try:
                    self.clientSocket.sendall(self.message + '\n')
                except socket.error as err:
                    print('\n###Error -> {}'.format(str(err)))
                    sys.exit(2)
            counter+=1
            sleep(self.interval)

def redirectOutput(outFile):
    print('Redirecting STDOUT to: {}'.format(outFile))
    sys.stdout = open(outFile, 'w')

def restoreOutput():
    if sys.stdout != sys.__stdout__:
        outFile = sys.stdout
        sys.stdout = sys.__stdout__
        outFile.close()
        print('Restored STDOUT output from file: {}'.format(outFile))

def toMillis(dtime):
    retVal = 0
    if dtime:
        epoch = int(round(time() * 1000))
        diffTime = dtime - epoch
        retVal = diffTime.total_seconds() * 1000000.0

    return retVal

def calcDiffTime(time1, time2):
    timeDiff = 0
    if time1 and time2 and time1.isValid and time2.isValid:
        t1 = toMillis(time1.timeStamp)
        t2 = toMillis(time2.timeStamp)
        if t2 < t1:
            timeDiff = t1 - t2
        else:
            timeDiff = t2 - t1

    return timeDiff

def humanReadableTime(timeInMicroseconds):
    delta = timedelta(microseconds=timeInMicroseconds)
    total_seconds = delta.seconds
    seconds = total_seconds%60
    minutes = total_seconds/60%60
    hours = total_seconds/3600
    microseconds = delta.microseconds
    # Using format: HH:MM:SS.uuuuuu
    strLine = '%.2d:%.2d:%.2d.%.6d' % ( hours, minutes, seconds, microseconds )

    return strLine

def humanReadableBytes(bytesSize):
    kb, mb, gb, tb = 2**10, 2**20, 2**30, 2**40
    if 0 <= bytesSize <= kb:
        retVal = '%.3f[bytes]' % bytesSize
    elif kb < bytesSize <= mb:
        retVal = '%.3f[Kb]' % round(bytesSize/kb,3)
    elif mb < bytesSize <= gb:
        retVal = '%.3f[Mb]' % round(bytesSize/mb,3)
    elif gb < bytesSize <= tb:
        retVal = '%.3f[Gb]' % round(bytesSize/gb,3)
    else:
        retVal = '%.3f[Tb]' % round(bytesSize/tb,3)

    return retVal

def fitToColumns(message):
    msgLen = len(message)
    if msgLen > 0:
        message = '%s' % (
            (
                message[:MAX_DISPLAYED_MSG_LEN] + ' ...more<%s>' % humanReadableBytes(msgLen)
            ) if msgLen > MAX_DISPLAYED_MSG_LEN else message
        )

    return message, msgLen

def main(cmdArgs):
    port=12345
    address='127.0.0.1'
    packets=100
    interval=1.0
    threads = 1
    netType = NET_TYPE_TCP

    try:
        if len(sys.argv) == 1 or sys.argv[1] in [ '-h', '--help' ]:
            usage()

        # pylint: disable=W0612
        opts, args = getopt.getopt(cmdArgs, 'hvm:p:a:k:i:t:n:', ['help', 'version', 'message=', 'port=', 'address=', 'packets=', 'interval=', 'threads=', 'netType'])

        for opt, argument in opts:
            if opt in ('-v', '--version'):
                version()
            elif opt in ('-h', '--help'):
                usage(0)
            elif opt in ('-m', '--message'):
                if os.path.isfile(argument):
                    fsize = os.stat(argument).st_size
                    print('Reading contents from file: %s (%d) [Bs] instead' % (argument, fsize))
                    with open(argument, 'r') as fMsg:
                        message = fMsg.read()
                else:
                    message = argument
            elif opt in ('-p', '--port'):
                assert argument.isdigit() and 0 < int(argument) <= 65535, 'Port Number must be a digit within 1-65535]'
                port = int(argument)
            elif opt in ('-a', '--address'):
                address = argument
            elif opt in ('-k', '--packets'):
                assert argument.isdigit() and 0 <= int(argument), 'Number of packets must be a digit within [0-N]'
                packets = int(argument)
            elif opt in ('-i', '--interval'):
                assert argument.isdigit() and 0 < int(argument), 'Interval must be a digit within [1-N]'
                interval = abs(Decimal(argument) / 1000)
            elif opt in ('-t', '--threads'):
                assert argument.isdigit() and 0 < int(argument) <= MAX_THREADS, 'Number of threads must be a digit within [1-%d]' % MAX_THREADS
                threads = int(argument)
            elif opt in ('-n', '--netType'):
                netType = str(argument).upper()
                assert netType == 'UDP' or netType == 'TCP', 'Network type must be either UDP or TCP'
            else:
                assert False, 'Unhandled option: %s' % opt

        message='{}SendMsg.py SELF TEST'.format(netType)
        p = TcpUdpIpSender(address, port, packets, interval, message, threads, netType)
        p.startSending()

    # Caught getopt exceptions
    except (getopt.GetoptError, AssertionError) as err:
        print('\n###Error -> {}'.format(str(err)))
        usage(2)

    # Ignore sys.exit
    except SystemExit:
        pass

    # Caught all other exceptions
    except:
        print('### A unexpected exception was thrown executing the app => \n\t{}'.format( str(sys.exc_info()[0]) ))
        sys.exit(2)

    sys.exit(0)

if __name__ == '__main__':
    main(sys.argv[1:])