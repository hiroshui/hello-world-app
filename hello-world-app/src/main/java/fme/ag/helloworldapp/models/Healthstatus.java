package fme.ag.helloworldapp;

public class Healthstatus {

	private final long id;
	private final String content;

	public Healthstatus(long id, String aiContent) {
		this.id = id;
		this.content = aiContent;
	}

	public long getId() {
		return id;
	}

	public String getContent() {
		return content;
	}
}