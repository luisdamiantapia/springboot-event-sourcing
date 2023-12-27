package app.stream.repository;

import app.stream.entity.WikimediaData;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WikimediaRepository extends JpaRepository<WikimediaData, Long> {
}
