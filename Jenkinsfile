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
        stage('Executing Terraform')
        {
            steps{
                script{
                    dir('terraform'){
                    sh 'terraform init'
                    }
                
                }
            }
        }
        stage('Applying Terraform')
        {
            steps{
                script{
                    echo "Terraform action is --> ${action}"
                    sh ('terraform ${action} --auto-approve')
                }
            }
        }
        /*stage('Executing Terraform')
        {
            steps{
                script{
                    sh te
                }
            }
        }

        stage('Stop Running Containers'){
            steps{
                sh 'docker ps -f name=node-app -q | xargs --no-run-if-empty docker container stop'
                sh 'docker container ls -a -fname=node-app -q | xargs -r docker container rm'
            }
        }
        stage('Docker Run'){
            steps{
                script{
                    sh 'docker run -d -p 8080:8080 --rm --name node-app 396785848384.dkr.ecr.us-east-1.amazonaws.com/jenkins-pipeline-docker-images:latest'
                }
            }
        }*/
    }
}
