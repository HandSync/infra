from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC, InternetGateway, RouteTable, ELB
from diagrams.aws.compute import EC2
# from diagrams.aws.database import
from diagrams.aws.storage import S3, EBS
from diagrams.aws.management import Cloudwatch
from diagrams.onprem.client import Users

with Diagram(
    "Arquitetura AWS HandSync",
    outformat="png",
    show=True,
    filename="Arquitetura de Redes - HandSync",
    ):
    Users = Users("User")
    # igw = InternetGateway("Internet Gateway")

    # client >> igw

    with Cluster("AWS - Rede Externa", graph_attr={"bgcolor": "#f7ebda"}):

        igw = InternetGateway("Internet Gateway")
        rt = RouteTable("Route Table")
        Users >> igw

        with Cluster("VPC - Rede principal", graph_attr={"bgcolor": "#f5dab4ce"}):

            cloudWatch = Cloudwatch("CloudWatch")
            vpc = VPC("VPC")


            igw >> rt

            elb_public = ELB("ELB Pública")
            elb_private = ELB("ELB Privada")

            rt >> vpc

            with Cluster("Availability Zone 2", graph_attr={"style": "dashed"}):
                with Cluster("Subnet Publica 1"):
                    fe1 = EC2("Instância Front-end")
                    ebs3 = EBS("EBS")
                with Cluster("Subnet Publica 2"):
                    fe2 = EC2("Instância Front-end")
                    ebs4 = EBS("EBS")

            with Cluster("Availability Zone 1", graph_attr={"style": "dashed"}):
                with Cluster("Subnet Privada 1"):
                    be1 = EC2("Instância Back-end")
                    ebs1 = EBS("EBS")
                with Cluster("Subnet Privada 2"):
                    be2 = EC2("Instância Back-end")
                    ebs2 = EBS("EBS")


            
        # # elb_public >> [fe1, fe2]
        be1 >> ebs1
        be2 >> ebs2
        ebs1 >> be2
        fe1 >> ebs3
        
        fe2 >> ebs4
        ebs3 >> fe2
        # ebs1 >> elb_private
        # ebs2 >> elb_private
        elb_private >> ebs1
        elb_private >> be2
        elb_public >> ebs3
        elb_public >> fe2
        # elb_public >> elb_private
        vpc >> [be1, fe1]
        # fe1 >> be1 >> ebs1
        # fe2 >> be2 >> ebs2
        # # s3 = S3("Bucket S3")
        # # ebs1 >> s3
        # # ebs2 >> s3

    