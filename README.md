# Salon Appointment Scheduler

A command-line interface (CLI) application built with **Bash** and **PostgreSQL** that allows users to book salon appointments, check available services, and automatically manage customer records. This project was developed as part of the freeCodeCamp Relational Database certification path.

---

## 🛠️ Key Design Highlights

* **Modular Bash Architecture:** Separation of concerns using dedicated control loops and functions (`MAIN_MENU` and `APPOINTMENT_MENU`) to manage flow control and error handling gracefully.
* **Whitespace & Output Normalization:** Utilizes `sed` with regular expressions (`sed 's/^ *| *$//g'`) to strip unwanted trailing spaces and pipe characters from PostgreSQL tuples-only output streams.
* **Relational Database Integration:** Implements foreign key constraints linking `appointments` to both `customers` and `services`, ensuring data integrity across tables.
* **Dynamic Customer Management:** Automatically checks if a phone number exists in the database; if not, seamlessly prompts for the customer's name and registers them before finalizing the booking.
* **Robust Input Validation:** Uses regular expressions (`=~ ^[0-9]+$`) to validate numeric choices and handles invalid options by looping back to the main menu with helpful error feedback.

---

## 📁 Project Structure

* `salon.sql` — The PostgreSQL database dump containing schema definitions (`customers`, `services`, `appointments`) and initial service seed data.
* `salon.sh` — The main interactive Bash script driving the user interface and database queries.

---

## 🚀 Getting Started

### Prerequisites

* **PostgreSQL** installed and running on your system.
* **Bash** shell environment (Linux, macOS, or WSL on Windows).

### 1. Clone the Repository

Clone the project to your local machine:

```bash
git clone https://github.com/Gibson1978/FreeCodeCamp-Salon-Appointment-Project.git
cd FreeCodeCamp-Salon-Appointment-Project

```

### 2. Set Up and Populate the Database

You can create the salon database and restore its schema and tables directly from the provided SQL dump file using `psql`:

```bash
psql -U postgres < salon.sql

```

*(Note: Ensure your PostgreSQL user has the necessary privileges, or modify the `--username=` flag in `salon.sh` if you use a different database role).*

### 3. Grant Execution Permissions to the Script

Make sure the Bash script is executable:

```bash
chmod +x salon.sh

```

### 4. Run the Application

Launch the appointment scheduler in your terminal:

```bash
./salon.sh

```

---

## 🗄️ Database Schema Overview

* **`services`**: Stores available salon treatments (e.g., cut, color, perm, style, trim).
* **`customers`**: Stores client contact info, mapped uniquely by phone number.
* **`appointments`**: Junction table connecting customers to their chosen services and scheduled times.
