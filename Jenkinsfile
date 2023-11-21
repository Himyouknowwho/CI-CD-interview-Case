pipeline {
    parameters {
      booleanParam(
        name : 'ENABLE_TESTING',
        defaultValue : true,
        description : '''Specify if you want to run tests on this build.
Set to true for testing, and false for no testing.'''
      )
    }
  options {
    buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '30'))
  }
  
  environment {
    registryCredentialSet = 'ghcr:docker registry'
    registryUri = 'https://ghcr.io'
  }

  stages {
    stage('Pre-test cleanup') {
      when {
        expression { return params.ENABLE_TESTING}
      }
      steps {
      }
    }
    //Commit stage testing
    stage('Unit test of last commit') {
      when {
        expression { return params.ENABLE_TESTING }
      }
      steps {
        warnError('Latest commit failed unit tests') {
            sh 'CI=true yarn test --passWithNoTests --lastCommit'
        }
      }
    }
    stage('Build React app') {
      steps {
        script {
          docker.withRegistry(registryUri, registryCredentialSet) {
            repo      = "CICD-case"
            buildImage = "gcr.io/Energinet/" + repo + ":build"
            buildArgs  = "."
            app = docker.build( buildImage, buildArgs )
          }
        }
      }
    }
    stage('Build webserver') {
      steps {
        dir( "web_server" ) {
          writeFile(
              file: "Dockerfile",
              text: """\
FROM ${buildImage} AS content
FROM nginx
EXPOSE 80
COPY --from=content /var/www/html /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
"""
          )
          script {
            jobName_a  = env.JOB_NAME.split( '/' )
            tag        = URLDecoder.decode( jobName_a[1] ).replaceAll( '/', '-' )
            webServer = docker.build( "gcr.io/Energinet/" + repo + ":" + tag )
          }
        }
      }
    }
    stage('Push app image') {
      steps {
        script {
          jobName_a = env.JOB_NAME.split( '/' )
          tag       = URLDecoder.decode( jobName_a[1] ).replaceAll( '/', '-' )
          docker.withRegistry(registryUri, registryCredentialSet) {
            commitId = sh(returnStdout: true, script: 'git rev-parse HEAD').trim() 
            webServer.push("${tag}-${env.BUILD_NUMBER}")
            webServer.push("${tag}")
            webServer.push("${commitId}")
            if ( tag == "master" ||  tag == "main" )
              webServer.push("latest")
          }
        }
      }
    }
    //Regression testing -> Unit Testing
    stage('All unit test') {
      when {
        expression { return params.ENABLE_TESTING }
      }
      steps {
        warnError('Full unit test suite failed') {
          sh 'CI=true yarn test'
        }  
      }
    }
    stage('End-2-End-test') {
      when {
        expression { return params.ENABLE_TESTING }
      }
      steps {
        echo 'run E2E test'
      }
    }
  }
  stage('Deploy to development env') {
    steps {
        echo 'deploy to nightly'
    }
  }
}
