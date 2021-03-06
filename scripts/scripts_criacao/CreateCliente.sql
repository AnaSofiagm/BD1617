CREATE USER 'agencia.cliente'@'localhost'
IDENTIFIED BY 'Agencia';
/*Concedem-se os provilégios de inserção, atualização e seleção:*/
GRANT INSERT,UPDATE,SELECT
ON Agencia.Cliente
TO 'agencia.cliente'@'localhost';
/*E retira-se o privilégio de remoção na tabela Cliente :*/
REVOKE DELETE
ON Agencia.Cliente
FROM 'agencia.cliente'@'localhost';