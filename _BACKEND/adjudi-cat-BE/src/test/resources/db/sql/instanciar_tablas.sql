DROP TABLE IF EXISTS adj_oferta;
DROP TABLE IF EXISTS adj_favorits;
DROP TABLE IF EXISTS adj_missatge;
DROP TABLE IF EXISTS adj_valoracio;
DROP TABLE IF EXISTS adj_usuari_login_fallido;
DROP TABLE IF EXISTS adj_relacio_articles;
DROP TABLE IF EXISTS adj_chatbot;
DROP TABLE IF EXISTS adj_contracte;
DROP TABLE IF EXISTS adj_ambit;
DROP TABLE IF EXISTS adj_lot;
DROP TABLE IF EXISTS adj_usuari;
DROP TABLE IF EXISTS adj_organ;
DROP TABLE IF EXISTS adj_departament;
DROP TABLE IF EXISTS adj_idioma;
DROP TABLE IF EXISTS adj_rol;

CREATE TABLE adj_rol (
   id_rol int GENERATED BY DEFAULT AS IDENTITY,
   codi varchar(8) NOT NULL,
   nom varchar(16) NOT NULL,
   visible BOOLEAN NOT NULL,
   PRIMARY KEY (id_rol),
   UNIQUE (codi)
);

CREATE TABLE adj_idioma (
  id_idioma int GENERATED BY DEFAULT AS IDENTITY,
  codi varchar(8) NOT NULL,
  nom varchar(16) NOT NULL,
  PRIMARY KEY (id_idioma),
  UNIQUE (codi)
);

CREATE TABLE adj_departament (
   id_departament int GENERATED BY DEFAULT AS IDENTITY,
   codi int DEFAULT NULL,
   nom varchar(128) DEFAULT NULL,
   PRIMARY KEY (id_departament),
   UNIQUE (codi)
);

CREATE TABLE adj_organ (
 id_organ int GENERATED BY DEFAULT AS IDENTITY,
 codi int DEFAULT NULL,
 nom varchar(128) DEFAULT NULL,
 id_departament int DEFAULT NULL,
 PRIMARY KEY (id_organ),
 UNIQUE (codi),
 CONSTRAINT adj_organ_ibfk_1 FOREIGN KEY (id_departament) REFERENCES adj_departament (id_departament)
);

CREATE TABLE adj_usuari (
  id_usuari int GENERATED BY DEFAULT AS IDENTITY,
  nom varchar(128) NOT NULL,
  email varchar(128) NOT NULL,
  contrasenya varchar(64) NOT NULL,
  telefon varchar(16) DEFAULT NULL,
  notificicacions_actives BOOLEAN DEFAULT NULL,
  descripcio varchar(255) DEFAULT NULL,
  enllac_perfil_social varchar(255) DEFAULT NULL,
  ident_nif varchar(128) DEFAULT NULL,
  bloquejat BOOLEAN DEFAULT NULL,
  id_organ int DEFAULT NULL,
  id_idioma int NOT NULL,
  id_rol int NOT NULL,
  pais varchar(32) DEFAULT NULL,
  codi_postal int DEFAULT NULL,
  direccio varchar(128) DEFAULT NULL,
  PRIMARY KEY (id_usuari),
  CONSTRAINT adj_usuari_ibfk_1 FOREIGN KEY (id_organ) REFERENCES adj_organ (id_organ),
  CONSTRAINT adj_usuari_ibfk_2 FOREIGN KEY (id_idioma) REFERENCES adj_idioma (id_idioma),
  CONSTRAINT adj_usuari_ibfk_3 FOREIGN KEY (id_rol) REFERENCES adj_rol (id_rol)
);

CREATE TABLE adj_lot (
   id_lot int GENERATED BY DEFAULT AS IDENTITY,
   numero varchar(32) DEFAULT NULL,
   descripcio varchar(255) DEFAULT NULL,
   PRIMARY KEY (id_lot),
   UNIQUE (numero)
);

CREATE TABLE adj_ambit (
 id_ambit int GENERATED BY DEFAULT AS IDENTITY,
 codi int DEFAULT NULL,
 nom varchar(128) DEFAULT NULL,
 PRIMARY KEY (id_ambit),
 UNIQUE (codi)
);

CREATE TABLE adj_contracte (
 id_contracte int GENERATED BY DEFAULT AS IDENTITY,
 codi_expedient varchar(255) DEFAULT NULL,
 tipus_contracte varchar(128) DEFAULT NULL,
 subtipus_contracte varchar(512) DEFAULT NULL,
 procediment varchar(255) DEFAULT NULL,
 objecte_contracte varchar(512) DEFAULT NULL,
 pressupost_licitacio double DEFAULT NULL,
 valor_estimat_contracte double DEFAULT NULL,
 lloc_execucio varchar(255) DEFAULT NULL,
 duracio_contracte varchar(255) DEFAULT NULL,
 termini_presentacio_ofertes datetime DEFAULT NULL,
 data_publicacio_anunci datetime DEFAULT NULL,
 ofertes_rebudes int DEFAULT NULL,
 resultat varchar(64) DEFAULT NULL,
 enllac_publicacio varchar(255) DEFAULT NULL,
 data_adjudicacio_contracte datetime DEFAULT NULL,
 id_ambit int DEFAULT NULL,
 id_lot int DEFAULT NULL,
 id_usuari_creacio int NOT NULL,
 PRIMARY KEY (id_contracte),
 UNIQUE (codi_expedient),
 CONSTRAINT adj_contracte_ibfk_1 FOREIGN KEY (id_ambit) REFERENCES adj_ambit (id_ambit),
 CONSTRAINT adj_contracte_ibfk_2 FOREIGN KEY (id_lot) REFERENCES adj_lot (id_lot),
 CONSTRAINT adj_contracte_ibfk_3 FOREIGN KEY (id_usuari_creacio) REFERENCES adj_usuari (id_usuari)
);

CREATE TABLE adj_chatbot (
   id_articulo int GENERATED BY DEFAULT AS IDENTITY,
   texto varchar(1023) NOT NULL,
   PRIMARY KEY (id_articulo)
);

CREATE TABLE adj_relacio_articles (
    palabra varchar(16) NOT NULL,
    id_articulo int NOT NULL,
    PRIMARY KEY (palabra),
    CONSTRAINT adj_relacio_articles_ibfk_1 FOREIGN KEY (id_articulo) REFERENCES adj_chatbot (id_articulo)
);

CREATE TABLE adj_usuari_login_fallido (
    id_login_fallido int GENERATED BY DEFAULT AS IDENTITY,
    numero_intentos int NOT NULL,
    data_finalizacion_ban datetime NOT NULL,
    id_usuari int NOT NULL,
    PRIMARY KEY (id_login_fallido),
    CONSTRAINT adj_usuari_login_fallido_ibfk_1 FOREIGN KEY (id_usuari) REFERENCES adj_usuari (id_usuari)
);

CREATE TABLE adj_valoracio (
     id_valoracio int GENERATED BY DEFAULT AS IDENTITY,
     puntuacio int NOT NULL,
     descripcio varchar(255) DEFAULT NULL,
     data_hora_valoracio datetime NOT NULL,
     id_empresa_valorada int NOT NULL,
     id_organisme int NOT NULL,
     PRIMARY KEY (id_valoracio),
     CONSTRAINT adj_valoracio_ibfk_1 FOREIGN KEY (id_empresa_valorada) REFERENCES adj_usuari (id_usuari),
     CONSTRAINT adj_valoracio_ibfk_2 FOREIGN KEY (id_organisme) REFERENCES adj_usuari (id_usuari)
);

CREATE TABLE adj_missatge (
    id_missatge int GENERATED BY DEFAULT AS IDENTITY,
    missatge varchar(255) NOT NULL,
    data_hora_envio datetime NOT NULL,
    id_emissor int NOT NULL,
    id_receptor int NOT NULL,
    PRIMARY KEY (id_missatge),
    CONSTRAINT adj_missatge_ibfk_1 FOREIGN KEY (id_emissor) REFERENCES adj_usuari (id_usuari),
    CONSTRAINT adj_missatge_ibfk_2 FOREIGN KEY (id_receptor) REFERENCES adj_usuari (id_usuari),
    CONSTRAINT adj_missatge_chk_1 CHECK ((id_emissor <> id_receptor))
);

CREATE TABLE adj_favorits (
    id_favorit int GENERATED BY DEFAULT AS IDENTITY,
    id_usuari int NOT NULL,
    id_contracte int NOT NULL,
    PRIMARY KEY (id_favorit),
    UNIQUE (id_usuari,id_contracte),
    CONSTRAINT adj_favorits_ibfk_1 FOREIGN KEY (id_usuari) REFERENCES adj_usuari (id_usuari),
    CONSTRAINT adj_favorits_ibfk_2 FOREIGN KEY (id_contracte) REFERENCES adj_contracte (id_contracte)
);

CREATE TABLE adj_oferta (
  id_oferta int GENERATED BY DEFAULT AS IDENTITY,
  id_contracte int NOT NULL,
  id_empresa int NOT NULL,
  data_hora_oferta datetime DEFAULT NULL,
  import_adjudicacio_sense double DEFAULT NULL,
  import_adjudicacio_amb_iva double DEFAULT NULL,
  ganadora BOOLEAN NOT NULL,
  PRIMARY KEY (id_oferta),
  UNIQUE (id_contracte,id_empresa),
  CONSTRAINT adj_oferta_ibfk_1 FOREIGN KEY (id_contracte) REFERENCES adj_contracte (id_contracte),
  CONSTRAINT adj_oferta_ibfk_2 FOREIGN KEY (id_empresa) REFERENCES adj_usuari (id_usuari)
)