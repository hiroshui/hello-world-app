package fme.ag.helloworldapp;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthstatusController {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();

	@GetMapping("/healthz")
	public Healthstatus greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		return new Healthstatus(counter.incrementAndGet(), String.format(template, name));
	}
}