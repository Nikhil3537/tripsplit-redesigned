# 💰 TripSplit – Expense Sharing Web Application

TripSplit is a full-stack **expense-sharing web application built with Ruby on Rails** that helps groups manage trip expenses, track individual contributions, and calculate settlements easily.

The application is designed for friends, families, and groups who want a simple way to split expenses and keep track of who owes whom.

## 🚀 Live Demo

🔗 **Live Application:** https://tripsplit-redesigned.onrender.com

---

## ✨ Features

* 🔐 User registration and secure authentication
* 👥 Create and manage trips
* 💸 Add and track trip expenses
* 🧮 Automatic expense splitting and settlement calculation
* 🔗 Invite members using shareable invite links
* 📩 Join-request management
* ✅ Trip-owner approval workflow
* 📊 Track individual contributions and balances
* 💰 View who owes whom
* 📱 Responsive user interface
* 🗄️ Database-backed expense management

---

## 🛠️ Tech Stack

### Backend

* **Ruby**
* **Ruby on Rails**
* **RESTful APIs**
* **ActiveRecord**

### Frontend

* HTML5
* CSS3
* JavaScript

### Database

* PostgreSQL

### Development & Deployment

* Git
* GitHub
* Render
* VS Code
* Antigravity
* Claude AI
* ChatGPT

---

## 🏗️ Application Workflow

```text
User Registration
       ↓
   Create Trip
       ↓
 Invite Members
       ↓
 Members Join Trip
       ↓
 Owner Approves Requests
       ↓
 Add Trip Expenses
       ↓
 Calculate Individual Shares
       ↓
 Track Balances
       ↓
 Settlement Calculation
```

---

## 📂 Project Structure

```text
TripSplit/
│
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   ├── helpers/
│   └── assets/
│
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── environments/
│
├── db/
│   ├── migrate/
│   └── schema.rb
│
├── public/
├── test/
├── Gemfile
├── Gemfile.lock
└── README.md
```

---

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/tripsplit.git
cd tripsplit
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Configure Database

Update your database configuration if required and create the database:

```bash
rails db:create
```

### 4. Run Migrations

```bash
rails db:migrate
```

### 5. Start the Rails Server

```bash
rails server
```

The application will be available at:

```text
http://localhost:3000
```

---

## 🧮 Expense Splitting

TripSplit allows users to:

1. Create a trip.
2. Add members to the trip.
3. Record expenses.
4. Assign expenses to participants.
5. Calculate each member's share.
6. Track balances.
7. Determine settlement amounts.

This reduces manual calculations and makes group expense management easier.

---

## 🔐 Authentication & Authorization

The application includes user authentication and role-based workflows.

### User

* Create an account
* Login/logout
* Join trips
* Add expenses
* View balances

### Trip Owner

* Create trips
* Invite members
* Approve join requests
* Manage trip expenses
* View settlement information

---

## 🌐 Deployment

TripSplit is deployed using **Render**.

🔗 Live Demo: https://tripsplit-redesigned.onrender.com

---

## 🔮 Future Enhancements

* 📱 Mobile application
* 💳 Online payment integration
* 📧 Email notifications
* 🔔 Expense reminders
* 📈 Expense analytics and charts
* 🤝 Multiple currency support
* 📄 Export expenses to PDF/Excel
* 🔐 OAuth login with Google/GitHub
* 💬 Trip-based group communication

---

## 🎯 Project Objectives

The main objectives of TripSplit are:

* Simplify group expense management.
* Automate expense calculations.
* Reduce settlement-related confusion.
* Provide transparent expense tracking.
* Implement a real-world full-stack application using Ruby on Rails.

---

## 👨‍💻 Developer

**Nikhil N S**

**Ruby on Rails Developer | Python Developer**

* GitHub: https://github.com/Nikhil3537
* LinkedIn: Add your LinkedIn profile here

---

## 📄 License

This project is developed for **educational and portfolio purposes**.
