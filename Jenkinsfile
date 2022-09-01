pipeline {
    agent {dockerfile true}
    stages{
        stage('source'){
            environment {
                  HOME="."
                }
        steps{
            git 'git@github.com:Venkateshharish/devOps.git'
        }
    }
    stage('Running Build'){
    steps{
        echo 'Docker file has been successfully bulit'
    }
    }
}
}
