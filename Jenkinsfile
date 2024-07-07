pipeline {
  agent { 
        node {
            label 'agent1'
            }
      }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('autopilotsedate66-dockerhub')
  }
  stages {
    stage('Clone Repository') {
      steps {
        // Clone your repository
        checkout scm
      }
    }
    stage('Build') {
      steps {
        dir('all_in_docker/client') {
          script {
            sh 'docker build -t autopilotsedate66/frontend:latest .'
          }
        }
      }
    }
    // running the container
    stage('Running container') {
      steps {
        sh 'docker run -d -p 80:80 autopilotsedate66/frontend'
      }
    }
    
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push autopilotsedate66/frontend:latest'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
