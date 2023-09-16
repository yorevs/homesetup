#!/usr/bin/env groovy

pipeline {
  agent {
    node {
      // Alpine JDK-11 and Python v3.11.5
      label 'docker-agent-python3'
    }
  }

  options {
    ansiColor('xterm')
  }

  environment {
    USER = 'jenkins'
    GROUP = 'jenkins'
    HOME = "/home/jenkins"
    HHS_PREFIX = "${WORKSPACE}"
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
            ./install.bash -r -p ${HHS_PREFIX}
          '''
        }
      }
    }

    stage('Bats Tests') {
      steps {
        script {
          sh '''#!/bin/bash
            echo "${HHS_PREFIX}" > "${HOME}/.hhs-prefix"
            if source "${HOME}"/.bashrc; then
              __hhs tests
            else
              echo "Unable to source required test scripts"
              exit 1
            fi
          '''
        }
      }
    }

  }

  post {
    always {
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

    print("info: APP_NAME=${props['app_name']}")
    print("info: APP_VERSION=${props['app_version']}")
    print("info: BASH_VERSION=${props['bashVersion']}")
    print("info: PYTHON_VERSION=${props['pythonVersion']}")
  }
}
