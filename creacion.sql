create database sacc;

use sacc;

CREATE TABLE nutriologo (
    matricula INT PRIMARY KEY NOT NULL,
    nombre TEXT NOT NULL,
    grupo INT NOT NULL,
    fechaNac DATE NOT NULL
);

CREATE TABLE paciente (
    idPaciente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre TEXT NOT NULL,
    fechaNac DATE NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    direccion TEXT NOT NULL
);

CREATE TABLE consultorio(
    idConsultorio INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombreAula TEXT NOT NULL,
    ubicacion TEXT NOT NULL,
    nota TEXT
);

CREATE TABLE agenda(
    idAgenda INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    matricula INT NOT NULL,
    idPaciente INT NOT NULL,
    idConsultorio INT NOT NULL,
    fecha DATE,
    horaInicio TIME,
    horaFinal TIME,
    semestre INT NOT NULL,
    FOREIGN KEY (matricula) REFERENCES nutriologo(matricula),
    FOREIGN KEY (idPaciente) REFERENCES paciente(idPaciente),
    FOREIGN KEY (idConsultorio) REFERENCES consultorio(idConsultorio)
);

create table usuarios(
	idUsuario int primary key auto_increment not null,
	matricula int not null,
	usuario varchar(255) not null,
	contrasena varchar(255) not null,
	foreign key (matricula) references nutriologo(matricula) on delete restrict on update cascade	
);


