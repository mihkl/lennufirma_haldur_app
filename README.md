Localis jooksutamine

Installi endale PSQL 17
Kui tekib probleeme, et PATH variable ei seti automaatselt https://stackoverflow.com/questions/15869808/postgres-psql-command-is-not-recognized-in-windows-environment

Klooni repo

AVA cmd ja pane kõik read ükshaaval
psql -U postgres -h localhost
CREATE DATABASE lennufirma_db;
CREATE USER lennufirma_user WITH PASSWORD 'user';
GRANT ALL PRIVILEGES ON DATABASE lennufirma_db TO lennufirma_user;
ALTER DATABASE lennufirma_db OWNER TO lennufirma_user;

Ava uus cmd kloonitud repo /sql kaustas
psql -U lennufirma_user -d lennufirma_db -h localhost -f lennufirma_setup.sql;
password on user nagu enne panid

Nüüd on andmebaas olemas ja jookseb

Installi PHP
Proovi cmds teha php --v, kui ütleb et on olemas siis kõik õigesti, ma pidin selle extracitud php zipi, mis alla laadisin /Program Files kausta panema ja
panema Windowsis PATH environment variablele juurde viite sellele kaustale
Mine kausta, kuhu installisid, tee fail php.ini, kui seda pole veel
Kopeeri sinna php.ini-development faili sisu
Võta ; ära extension=pdo_pgsql ja extension=pgsql ridade eest

Ava terminal lennufirma_haldur_app kaustas ja pane php -S localhost:8000
Mine browseris localhost:8000

