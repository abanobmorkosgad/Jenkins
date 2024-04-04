def gv
pipeline{
    agent any
    parameters{
        choice(name: 'Version', choices: ['1.0.1','1.0.2','1.0.3'], description: '')
        booleanParam(name: 'executeTest', defaultValue: true, description: '')
    }
    stages{
        stage("init"){
            steps{
                script{
                    gv = load "scipt.groovy"
                }
            }
        }
        stage("test"){
            when{
                expression{
                    params.executeTest == true
                }
            }
            steps{
                script{
                    gv.test()
                }
            }
        }
        stage("build"){
            steps{
                script{
                    gv.build()
                }
            }
        }
        stage("deploy"){
            steps{
                script{
                    gv.deploy()
                }
            }
        }
    }
}