package com.afa.modal;

public class FileDataModal {
	
	private int fileId=0;
	private String ownerOfFile="",fileName="",fileSize="",categoryOfFile="",urlOfFile="",dateCreated="",dateModified="",descOfFile="",dateExpiray="";
	
	public FileDataModal(int fileId, String ownerOfFile, String fileName, String fileSize, String categoryOfFile,
			String urlOfFile, String dateCreated, String dateModified, String descOfFile, String dateExpiray) {
		

		this.fileId = fileId;
		this.ownerOfFile = ownerOfFile;
		this.fileName = fileName;
		this.fileSize = fileSize;
		this.categoryOfFile = categoryOfFile;
		this.urlOfFile = urlOfFile;
		this.dateCreated = dateCreated;
		this.dateModified = dateModified;
		this.descOfFile = descOfFile;
		this.dateExpiray = dateExpiray;
		
	}

	public int getFileId() {
		return fileId;
	}

	public void setFileId(int fileId) {
		this.fileId = fileId;
	}

	public String getOwnerOfFile() {
		return ownerOfFile;
	}

	public void setOwnerOfFile(String ownerOfFile) {
		this.ownerOfFile = ownerOfFile;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getCategoryOfFile() {
		return categoryOfFile;
	}

	public void setCategoryOfFile(String categoryOfFile) {
		this.categoryOfFile = categoryOfFile;
	}

	public String getUrlOfFile() {
		return urlOfFile;
	}

	public void setUrlOfFile(String urlOfFile) {
		this.urlOfFile = urlOfFile;
	}

	public String getDateCreated() {
		return dateCreated;
	}

	public void setDateCreated(String dateCreated) {
		this.dateCreated = dateCreated;
	}

	public String getDateModified() {
		return dateModified;
	}

	public void setDateModified(String dateModified) {
		this.dateModified = dateModified;
	}

	public String getDescOfFile() {
		return descOfFile;
	}

	public void setDescOfFile(String descOfFile) {
		this.descOfFile = descOfFile;
	}

	public String getDateExpiray() {
		return dateExpiray;
	}

	public void setDateExpiray(String dateExpiray) {
		this.dateExpiray = dateExpiray;
	}
	
	
	
	

	
	
}
