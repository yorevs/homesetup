# .bash_env

if test "$(uname -s)" = "Linux"
then
    # For Linux
    export JAVA_HOME="/usr/lib/jvm/java-7-oracle"
    export PYTHON_HOME="/usr/bin"
    export QT_HOME="/usr"
    export ARM_GCC_HOME="/usr/local/arm"
    export ARM_LINUX_HOME="$ARM_GCC_HOME/4.1.1-920t"
    export ARM_CORTEX_HOME="$ARM_GCC_HOME/3.2.1-elf"
    export ARM_HISILICON_HOME=""
    export GLASSFISH_HOME="/opt/glassfish4"
    
    export PATH="$GLASSFISH_HOME/bin:$ARM_GCC_HOME:$ARM_LINUX_HOME/bin:$ARM_ELF_HOME/bin:$PATH"
elif test "$(uname -s)" = "Darwin"
then
    # For Mac
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk/Contents/Home"
    export PYTHON_HOME="/System/Library/Frameworks/Python.framework/Versions/Current"
    export QT_HOME="$HOME/Applications/Qt5.3.0/5.3/clang_64"
    export ARM_GCC_HOME=""
    export ARM_LINUX_HOME=""
    export ARM_CORTEX_HOME="/Applications/lpcxpresso_5.2.6_2137/lpcxpresso/tools"
    export ARM_HISILICON_HOME=""
    export DEV_HOME="/Applications/Xcode.app/Contents/Developer"
    export MACOS_SDK="$DEV_HOME/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk"
    export GLASSFISH_HOME=""
    
    export PATH="$GLASSFISH_HOME:$ARM_CORTEX_HOME/bin:$QT_HOME/bin:$PATH"
fi

