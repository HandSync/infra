from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC, InternetGateway, RouteTable, ELB
from diagrams.aws.compute import EC2
from diagrams.aws.storage import S3, EBS
from diagrams.aws.management import Cloudwatch
from diagrams.onprem.client import Users

with Diagram(
    outformat="png",
    show=True,
    filename="Arquitetura de Redes - HandSync",
    graph_attr={"label": "<<B>Arquitetura de Redes - HandSync</B>>", "labelloc": "t", "fontsize": "20"}
    ):

    Users = Users("User")

    with Cluster("<<B>AWS - Rede Externa</B>>", graph_attr={"bgcolor": "#f7ebda"}):
        
        igw = InternetGateway("Internet Gateway")
        rt = RouteTable("Route Table")
        Users >> igw

        with Cluster("<<B>Bucket S3</B>>", graph_attr={"style": "dashed"}):

            s3_raw = S3("<<B>RAW</B>>")
            s3_trusted = S3("<<B>TRUSTED</B>>")
            s3_curated = S3("<<B>CURATED</B>>")

        with Cluster("<<B>VPC - Rede principal</B>>", graph_attr={"bgcolor": "#f5dab4ce"}):

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

    be1 >> ebs1
    be2 >> ebs2
    ebs1 >> be2
    fe1 >> ebs3
    fe2 >> ebs4
    ebs3 >> fe2
    elb_private >> ebs1
    elb_private >> be2
    elb_public >> ebs3
    elb_public >> fe2
    vpc >> Edge(color="purple")>>[be1, fe1]

    