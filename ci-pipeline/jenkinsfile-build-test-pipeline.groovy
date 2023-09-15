#!/usr/bin/env groovy

// App definitions
def appName = 'homesetup'

// library identifier: 'pipeUtils@master',
//     retriever: modernSCM([
//         $class       : 'GitSCMSource',
//         credentialsId: 'github_token',
//         remote       : 'https://github.com/yorevs/seedjob-jenkins-repo.git'
//     ])

pipeline {
  agent {
    node {
      label 'docker-agent-python3'
    }
  }

  options {
    ansiColor('xterm')
  }

  environment {
    ROOT_PROJECT_NAME = "${appName}"
    SHELL = '/bin/bash'
    USER = 'jenkins'
    GROUP = 'jenkins'
  }

  stages {

    stage('Pre Build Actions') {
      steps {
        prepareBuild()
      }
    }

    stage('Install') {
      steps {
        script {
          sh '''#!/bin/bash
            export HOME=$(pwd)
            ./install.bash -r -p ${HOME}
          '''
        }
      }
    }

    stage('Activate') {
      steps {
        script {
          sh '''#!/bin/bash
          export HOME=$(pwd)
          reset
          source ${HOME}/.bashrc
          '''
        }
      }
    }

    stage('Test') {
      steps {
        script {
          sh "__hhs tests"
        }
      }
    }

  }

  post {
    success {
      // Delete the workspace after build is finished.
      deleteDir()
    }
  }
}

def prepareBuild() {
  script {
    // readProperties -> Ref:. https://github.com/jenkinsci/pipeline-utility-steps-plugin/blob/master/docs/STEPS.md
    def props = readProperties file: 'gradle.properties'
    props.each { p ->
      print("info: WITH PROPERTY: ${p}")
    }

    print("info: APP_VERSION=${props['app_version']}")
    print("info: APP_NAME=${props['app_name']}")
    print("info: BASH_VERSION=${props['bashVersion']}")
    print("info: PYTHON_VERSION=${props['pythonVersion']}")
  }
}
