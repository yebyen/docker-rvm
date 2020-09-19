def label = "worker-${UUID.randomUUID().toString()}"

podTemplate(label: label,
  yaml: """
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

  - name: test
    image: kingdonb/pzaexcp-api:test
    imagePullSecrets:
    - kingdonb-pull-secret
    securityContext:
      runAsUser: 1000
    command:
    - cat
    tty: true
"""
) {
  node(label) {
    def myRepo = checkout scm
    def gitCommit = myRepo.GIT_COMMIT
    def gitBranch = myRepo.GIT_BRANCH
    def shortGitCommit = "${gitCommit[0..10]}"
    def previousGitCommit = sh(script: "git rev-parse ${gitCommit}~", returnStdout: true)
 
    stage('Build') {
      container('docker') {
        withCredentials([[$class: 'UsernamePasswordMultiBinding',
          credentialsId: 'dockerhub',
          usernameVariable: 'DOCKER_HUB_USER',
          passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh """\
            docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
            docker build -t kingdonb/pzaexcp-api:${gitCommit} .
            docker push kingdonb/pzaexcp-api:${gitCommit}
            """.stripIndent()
        }
      }
    }
    stage('Test') {
      container('test') {
        sh """\
          bash --login -c '\
          export DATABASE_TEST_URL=oracle-enhanced://no-user@no-host:5432/none
          export DATABASE_URL=oracle-enhanced://no-user@no-host:5432/none

          bundle config app_config .bundle
          bundle config path /tmp/vendor/bundle
          bundle check && bundle exec rspec
          '
          """.stripIndent()
      }
    }
    stage('Push Test') {
      container('docker') {
        withCredentials([[$class: 'UsernamePasswordMultiBinding',
          credentialsId: 'dockerhub',
          usernameVariable: 'DOCKER_HUB_USER',
          passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh """
            docker tag kingdonb/pzaexcp-api:${gitCommit} kingdonb/pzaexcp-api:test
            docker push kingdonb/pzaexcp-api:test
            """.stripIndent()
        }
      }
    }
    /*
    stage('Run kubectl') {
      container('kubectl') {
        sh "kubectl version"
      }
    }
    stage('Run helm') {
      container('helm') {
        sh "helm list"
      }
    }
    */
  }
}
