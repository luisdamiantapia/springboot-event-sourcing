package app.stream.config;

import app.stream.entity.WikimediaData;
import app.stream.repository.WikimediaRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class KafkaConsumer {
    private static final Logger LOGGER = LoggerFactory.getLogger(KafkaConsumer.class);

    @Autowired
    private WikimediaRepository repository;

    @KafkaListener(
            topics = "wikimedia_recentchange",
            groupId = "sbGroup"
    )
    public void consumer(String eventMessage) {
        LOGGER.info(String.format("Message recieved -> %s", eventMessage));

        WikimediaData data = new WikimediaData();
        data.setWikiEventData(eventMessage);

        repository.save(data);
    }

}
