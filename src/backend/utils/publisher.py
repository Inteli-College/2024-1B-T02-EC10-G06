#!/usr/bin/env python
import pika
import sys
import typing


class Publisher:

    def __init__(self,host:str,port:int,user:str = None,password:str = None) -> None:
        if user and password:
            self.connection = pika.BlockingConnection(
                        pika.ConnectionParameters(
                            host=host,
                            port=port,
                            credentials=pika.PlainCredentials(user,password)))
        else:
            self.connection = pika.BlockingConnection(
                        pika.ConnectionParameters(
                            host=host,
                            port=port))     
              
    def queueDeclare(self,name:str):



        channel = self.getConnection().channel()

        channel.queue_declare(queue=name, durable=True)
        
    def exchangeDeclare(self,name:str,type :str = "fanout"):

        channel = self.getConnection().channel()

        channel.exchange_declare(exchange=name,
                         exchange_type=type)
        
    def send(self,message:str,exchangeName:str,routingKey:str):

        channel = self.getConnection().channel()

        print(f" [x] Sent {message}")

        channel.basic_publish(exchange=exchangeName,
                      routing_key=routingKey,
                      body=message)
        
    def sendLot(self,messageList: typing.Iterable):

        for message in messageList:

            self.send(message)

    def getConnection(self):
        if not self.connection or self.connection.is_closed:
            self.connection = pika.BlockingConnection(
                        pika.ConnectionParameters(
                            host='bridge',
                            port=5672))
        return self.connection