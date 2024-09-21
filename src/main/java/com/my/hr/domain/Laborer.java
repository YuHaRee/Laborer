package com.my.hr.domain;

import java.time.LocalDate;

import lombok.Data;

@Data
public class Laborer {
	private int laborerId;
	private String name;
	private LocalDate hireDate;
}
