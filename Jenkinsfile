def URL
def BRANCH
def CREDENTIALS

pipeline {
  agent { label 'swarm' }
  stages {
    stage ('Checkout and Clean') {
      steps {
        script {
          URL='http://gitlab.rindecuentas.org/equipo-qqw/poppins.git'
          BRANCH='*/master'
          CREDENTIALS='f28cf2d5-ce55-4f0b-9bad-c84376ce401d'
        }
          dir('new-dir') { sh 'pwd' }
          ansiColor('xterm') {
            checkout changelog: false, poll: false, scm:
            [$class:
             'GitSCM', branches: [[name: BRANCH]],
              doGenerateSubmoduleConfigurations: false,
              extensions: [],
              submoduleCfg: [],
              userRemoteConfigs:
              [[
                credentialsId: CREDENTIALS,
                url: URL
              ]]
            ]
          }
        echo "Clean container and Image"
        sh 'make clean'
      }
    }
    stage ('Build') {
      agent { label 'swarm' }
      steps {
        script {
          echo "Build container"
          sh 'make build'
        }
      }
    }
    stage ('Test') {
      agent { label 'swarm' }
      steps {
        script {
          echo "Test container"
          sh 'make test'
        }
      }
    }
    stage ('Release and Clean') {
      agent { label 'swarm' }
      steps {
        script {
          echo "Push container image to dockerhub registry"
          sh 'make release'
	  echo "Clean container ans Image"
	  sh 'make clean'
        }
      }
    }
  }
}
