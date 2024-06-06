env = StreamExecutionEnvironment.get_execution_environment()
# checkpointing is required for exactly-once or at-least-once guarantees
env.enable_checkpointing(...)

connection_config = RMQConnectionConfig.Builder() \
    .set_host("localhost") \
    .set_port(5000) \
    .build()

stream = env \
    .add_source(RMQSource(
        connection_config,
        "queueName",
        True,
        SimpleStringSchema(),
    )) \
    .set_parallelism(1)