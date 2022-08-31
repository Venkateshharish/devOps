node {
    checkout scm

    docker.withRegistry('https://registry.hub.docker.com', 'dockerHub') {

        def customImage = docker.build("aws10/dockerapp")

        /* Push the container to the custom Registry */
        customImage.push()
    }
}
