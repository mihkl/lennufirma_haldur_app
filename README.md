# Localis jooksutamine

## 1. Installi PostgreSQL 17

- Lae alla ja installi [PostgreSQL 17](https://www.postgresql.org/).
- Kui `psql` käsk ei tööta CMD-s, siis vaata juhendit:  
  [Postgres psql command is not recognized in Windows environment](https://stackoverflow.com/questions/15869808/postgres-psql-command-is-not-recognized-in-windows-environment).

---

## 2. Klooni repo

---

## 3. Loo andmebaas ja kasutaja

Ava CMD ja sisesta käsud ükshaaval:

```bash
psql -U postgres -h localhost
```

PSQL terminalis sisesta:

```sql
CREATE DATABASE lennufirma_db;
CREATE USER lennufirma_user WITH PASSWORD 'user';
GRANT ALL PRIVILEGES ON DATABASE lennufirma_db TO lennufirma_user;
ALTER DATABASE lennufirma_db OWNER TO lennufirma_user;
```

---

## 4. Lae ükles andmebaasi skeem

- Ava **uus** CMD aken.
- Liigu kloonitud repo `/sql` kausta.
- Käivita:

```bash
psql -U lennufirma_user -d lennufirma_db -h localhost -f lennufirma_setup.sql
```

- Kasutajanimi: `lennufirma_user`  
- Parool: `user` (nagu varem määrasid)

---

## 5. Installi PHP

- Lae alla ja installi PHP.
- Kontrolli, kas PHP töötab:

```bash
php --version
```

Kui käsu andmisel PHP ei tööta:
- Extrahi allalaetud PHP zip fail `C:\Program Files\PHP\` kausta.
- Lisa see kaust PATH environment variable'isse.

---

## 6. PHP seadistamine

- Mine PHP installatsiooni kausta.
- Kui puudub, siis loo fail `php.ini`.
- Kopeeri sinna `php.ini-development` faili sisu.
- Ava `php.ini` ja **eemalda ";"** järgmistelt ridadelt:

```ini
extension=pdo_pgsql
extension=pgsql
```

---

## 7. Käivita server

- Ava terminal **`lennufirma_haldur_app`** kaustas.
- Käivita:

```bash
php -S localhost:8000
```

Mine brauseris aadressile:  
[http://localhost:8000](http://localhost:8000)

---
