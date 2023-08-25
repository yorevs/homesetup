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
      label 'docker-agent-alpine'
    }
  }

  environment {

    ROOT_PROJECT_NAME = "${appName}"
    DEFAULT_BRANCH = 'master'
  }

  stages {

    stage('Pre Build Actions') {
      steps {
        prepareBuild()
      }
    }

    stage('Build') {
      steps {
        script {
          echo "Building HomeSetup"
        }
      }
    }

  }

  post {
    always {
      deleteDir()
    }
  }
}

def prepareBuild() {
  script {
    // readProperties -> Ref:. https://github.com/jenkinsci/pipeline-utility-steps-plugin/blob/master/docs/STEPS.md
    def props = readProperties file: 'gradle.properties'
    props.each { p ->
      print("WITH PROPERTY: ${p}")
    }

    print("APP_VERSION=${props['app_version']}")
    print("APP_NAME=${props['app_name']}")
    print("BASH_VERSION=${props['bashVersion']}")
    print("PYTHON_VERSION=${props['pythonVersion']}")
  }
}
