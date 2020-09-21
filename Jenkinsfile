pipeline {
  agent any
  stages {
    stage('Build') {
      agent {
        kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  volumes:
  - name: var-run-docker-sock
    hostPath:
      path: /var/run/docker.sock

  containers:
  - name: docker
    image: docker
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: var-run-docker-sock
"""
        }
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
      runAsUser: 1000
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
            bundle config app_config .bundle
            bundle config path /tmp/vendor/bundle
            # bundle check && bundle exec rspec
            bundle check && ruby --version
            '
            """.stripIndent()
        }
      }
    }
    stage('Push Test') {
      agent {
        kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  volumes:
  - name: var-run-docker-sock
    hostPath:
      path: /var/run/docker.sock

  containers:
  - name: docker
    image: docker
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: var-run-docker-sock
"""
        }
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
    /*
    stage('Run kubectl') {
      steps {
        container('kubectl') {
          sh "kubectl version"
        }
      }
    }
    stage('Run helm') {
      steps {
        container('helm') {
          sh "helm list"
        }
      }
    }
    */
  }
}
