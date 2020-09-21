pipeline {
  agent any
  stages {
    stage('Build') {
      agent {
        kubernetes { yamlFile "jenkins/docker-pod.yaml" }
      }
      steps {
        container('docker') {
          withCredentials([[$class: 'UsernamePasswordMultiBinding',
            credentialsId: 'dockerhub',
            usernameVariable: 'DOCKER_HUB_USER',
            passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
            sh """\
              docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
              docker build -t yebyen/docker-rvm:${env.GIT_COMMIT} .
              docker push yebyen/docker-rvm:${env.GIT_COMMIT}
              """.stripIndent()
          }
        }
      }
    }
    stage('Test') {
      agent {
        kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: test
    image: yebyen/docker-rvm:${env.GIT_COMMIT}
    imagePullSecrets:
    - yebyen-docker-hub
    securityContext:
      runAsUser: 0
    command:
    - cat
    tty: true
"""
        }
      }
      steps {
        container('test') {
          sh """\
            bash --login -c '\
            export DATABASE_TEST_URL=oracle-enhanced://no-user@no-host:5432/none
            export DATABASE_URL=oracle-enhanced://no-user@no-host:5432/none

            cd docker-rvm-test
            rvm install 2.7.1
            bundle config app_config .bundle
            bundle config path /tmp/vendor/bundle
            bundle install
            # bundle check && bundle exec rspec
            bundle check && ruby --version
            '
            """.stripIndent()
        }
      }
    }
    stage('Push Test') {
      agent {
        kubernetes { yamlFile "jenkins/docker-pod.yaml" }
      }
      steps {
        container('docker') {
          withCredentials([[$class: 'UsernamePasswordMultiBinding',
            credentialsId: 'dockerhub',
            usernameVariable: 'DOCKER_HUB_USER',
            passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
            sh """
              docker tag yebyen/docker-rvm:${env.GIT_COMMIT} yebyen/pzaexcp-api:${new Date().format("yyyyMMdd")}
              docker push yebyen/pzaexcp-api:${new Date().format("yyyyMMdd")}
              """.stripIndent()
          }
        }
      }
    }
  }
}
