USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/cliente.csv" AS row
CREATE (:Cliente {idCliente: toInt(row.idCliente) , Nome: row.Nome
, NroDocIdentif: row.NroDocIdentif , Rua: row.Rua , Local: row.Local
, CodPostal: row.CodPostal , Pais: row.Pais});

USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/comboio.csv" AS row
CREATE (:Comboio {NroComboio: toInt(row.NroComboio), Marca: row.Marca, Modelo:
row.Modelo});

USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/percurso.csv" AS row
CREATE (:Percurso {idPercurso: toInt(row.idPercurso), LocalPartida:
row.LocalPartida , LocalChegada: row.LocalChegada , Preco: toFloat(row.Preco)
, Comboio: toInt(row.Comboio)});

USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/itinerario.csv" AS row
CREATE (:Itinerario {idItinerario: toInt(row.idItinerario) , DataHoraPartida:
row.DataHoraPartida , DataHoraChegada: row.DataHoraChegada , Percurso:
toInt(row.Percurso)});

USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reserva.csv" AS row CREATE
(:Reserva {idReserva: toInt(row.idReserva) ,  DataReserva: row.DataReserva
, TotalReserva: toFloat(row.TotalReserva) , TotalBilhetes:
toInt(row.TotalBilhetes), Cliente: toInt(row.Cliente), Itinerario:
toInt(row.Itinerario)});

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/comboiolugar.csv" AS row
CREATE (:ComboioLugar {idComboioLugar: [toInt(row.NroLugar),
toInt(row.Comboio)], NroLugar: toInt(row.NroLugar) ,NroCarruagem:
toInt(row.NroCarruagem) , TipoLugar: row.TipoLugar , Comboio:
toInt(row.Comboio)});

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reservabilhete.csv" AS row
CREATE (:ReservaBilhete {idReservaBilhete:[toInt(row.NroLugar), 
toInt(row.Reserva)], Reserva: toInt(row.Reserva),  NroCarruagem:
toInt(row.NroCarruagem),  TipoLugar: row.TipoLugar,  NroBilhete:
toInt(row.NroBilhete),  NroLugar: toInt(row.NroLugar),  Comboio:
toInt(row.Comboio)});

schema await;

CREATE CONSTRAINT ON (a:Cliente) assert a.NroDocIdentif IS UNIQUE;

CREATE CONSTRAINT ON (a:Cliente) assert a.idCliente IS UNIQUE;

CREATE CONSTRAINT ON (a:Comboio) assert a.NroComboio IS UNIQUE;

CREATE CONSTRAINT ON (a:Itinerario) assert a.idItinerario IS UNIQUE;

CREATE CONSTRAINT ON (a:Percurso) assert a.idPercurso IS UNIQUE;

CREATE CONSTRAINT ON (a:Reserva) assert a.idReserva IS UNIQUE;

CREATE CONSTRAINT ON (lugar :ComboioLugar) assert lugar.idComboioLugar IS UNIQUE;

CREATE CONSTRAINT ON (bilhete :ReservaBilhete) assert bilhete.idReservaBilhete
IS UNIQUE;

CREATE INDEX ON :ComboioLugar(NroLugar);

CREATE INDEX ON :ComboioLugar(Comboio);

CREATE INDEX ON :ReservaBilhete(Reserva);

CREATE INDEX ON :ReservaBilhete(NroLugar);

CREATE INDEX ON :Itinerario(DataHoraPartida);

CREATE INDEX ON :Itinerario(DataHoraChegada);

CREATE INDEX ON :Reserva(DataReserva);

schema await;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/cliente.csv" AS row
MATCH (cliente:Cliente {idCliente: toInt(row.idCliente)})
MATCH (reserva:Reserva {idReserva: toInt(row.idReserva)})
MERGE (cliente)-[:CLIENTE_EFETUA_RESERVA]->(reserva);

schema await;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/percurso.csv" AS row
MATCH (percurso :Percurso {idPercurso: toInt(row.idPercurso)})
MATCH (comboio :Comboio {NroComboio: toInt(row.Comboio)})
MERGE (comboio)-[:COMBOIO_PERCORRE_PERCURSO]->(percurso);

schema await;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/itinerario.csv" AS row
MATCH (itinerario :Itinerario {idItinerario: toInt(row.idItinerario)})
MATCH (percurso :Percurso {idPercurso: toInt(row.Percurso)})
MERGE (percurso)-[:PERCURSO_INCLUI_ITINERARIO]->(itinerario);

schema await;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reserva.csv" AS row
MATCH (itinerario :Itinerario {idItinerario: toInt(row.Itinerario)})
MATCH (reserva :Reserva {idReserva: toInt(row.idReserva)})
MERGE (itinerario)-[:ITINERARIO_EM_RESERVA]->(reserva);

schema await;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/reservabilhete.csv" AS row
MATCH (bilhete :ReservaBilhete {Reserva: toInt(row.Reserva)})
MATCH (reserva :Reserva {idReserva: toInt(row.Reserva)})
MERGE (reserva)-[:RESERVA_INCLUI_BILHETE]->(bilhete);

schema await;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///home/bpereira/csv/comboiolugar.csv" AS row
MATCH (lugar :ComboioLugar {Comboio: toInt(row.Comboio)})
MATCH (comboio :Comboio {NroComboio: toInt(row.Comboio)})
MERGE (comboio)-[:COMBOIO_POSSUI_LUGAR]->(lugar);

schema await;

MATCH (p:Percurso)
REMOVE p.Comboio;

MATCH (i:Itinerario)
REMOVE i.Percurso;

MATCH (r:Reserva)
REMOVE r.Itinerario, r.Cliente;

MATCH (r:ReservaBilhete)
REMOVE r.Comboio;
