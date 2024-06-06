package sink;

import org.apache.flink.connector.base.DeliveryGuarantee;
import org.apache.flink.connector.mongodb.sink.MongoSink;
import org.apache.flink.streaming.api.datastream.DataStream;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;
import com.mongodb.client.model.InsertOneModel;
import org.bson.BsonDocument;

public class Main {

    public void main(String[] args) {
        var sink = sinkToMongo();
        stream.sinkTo(sink);

    }

    public MongoSink<String> sinkToMongo() {
        MongoSink<String> sink = MongoSink.<String>builder()
                .setUri("mongodb://user:password@127.0.0.1:27017")
                .setDatabase("my_db")
                .setCollection("my_coll")
                .setBatchSize(1000)
                .setBatchIntervalMs(1000)
                .setMaxRetries(3)
                .setDeliveryGuarantee(DeliveryGuarantee.AT_LEAST_ONCE)
                .setSerializationSchema(
                        (input, context) -> new InsertOneModel<>(BsonDocument.parse(input)))
                .build();
        return sink;
    }

    public void sinkToRabbitMQ() {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("localhost");
        try (Connection connection = factory.newConnection();
                Channel channel = connection.createChannel()) {
            channel.queueDeclare("hello", false, false, false, null);
            DeliverCallback deliverCallback = (consumerTag, delivery) -> {
                String message = new String(delivery.getBody(), "UTF-8");
                System.out.println(" [x] Received '" + message + "'");
            };
            channel.basicConsume("hello", true, deliverCallback, consumerTag -> {
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}