package vn.iotstar.service;

public class StorageProperties extends RuntimeException {
	private static final long serialVersionUID = 1L;

	public StorageProperties(String message) {
		super(message);
	}

	public StorageProperties(String message, Exception e) {
		super(message,e);
	}

}
