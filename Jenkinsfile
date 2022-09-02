pipeline{
    agent any
    environment{
        registry = "396785848384.dkr.ecr.us-east-1.amazonaws.com/jenkins-pipeline-docker-images"
    }
    stages{
        stage('Checkout'){
            steps{
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Venkateshharish/devOps']]])
            }
        }
        stage('Docker Build'){
            steps{
                script{
                    dockerImage = docker.build registry
                }
            }
        }
        stage('Docker Deploy to ECR'){
            steps{
                script{
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 396785848384.dkr.ecr.us-east-1.amazonaws.com'
                    sh 'docker push 396785848384.dkr.ecr.us-east-1.amazonaws.com/jenkins-pipeline-docker-images:latest'
                }
            }
        }
        stage('Docker Run'){
            steps{
                script{
                    sh 'docker run -d -t 8096:5000 --rm --name node-app 396785848384.dkr.ecr.us-east-1.amazonaws.com/jenkins-pipeline-docker-images:latest'
                }
            }
        }
    }
}
