# Full-Stack Flutter App

A comprehensive full-stack to-do application developed using Flutter for the frontend, and Node.js, Express.js for the backend. MongoDB, managed by Mongoose, serves as the database. This project demonstrates a complete full-stack application with user authentication, task management, and responsive design.

## Features

- **Flutter Frontend:** Modern, responsive, and intuitive user interface.
- **Node.js & Express.js Backend:** Robust and scalable server-side logic.
- **MongoDB & Mongoose:** Flexible and scalable NoSQL database management.
- **User Authentication:** Secure login and registration with JWT.
- **Task Management:** Create, update, and delete tasks.
- **Responsive Design:** Seamless experience across devices.

## Getting Started

### Prerequisites

- Node.js (v14 or later)
- MongoDB instance
- Flutter SDK

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/jaspal007/full-stack-flutter-app.git
   ```
2. Navigate to the backend directory:
   ```bash
   cd full-stack-flutter-app/backend
   ```
3. Install backend dependencies:
   ```bash
   npm install
   ```
4. Navigate to the frontend directory:
   ```bash
   cd ../frontend
   ```
5. Install frontend dependencies:
   ```bash
   flutter pub get
   ```

### Setup Environment Variables

Create a `.env` file in the backend directory and add the following environment variables:

```env
MONGODB_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key
```

### Running the Application

#### Backend

Start the backend server:

```bash
cd backend
npm run dev
```

#### Frontend

Run the Flutter application:

```bash
cd ../frontend
flutter run
```

## Usage

### Home Page

- View and manage your tasks.
- Add new tasks using the input field.
- Mark tasks as completed or delete them.

### Authentication

- Register a new account.
- Login with existing credentials.

## Project Structure

- **/backend:** Node.js and Express.js server-side code.
- **/frontend:** Flutter client-side code.
- **/models:** Mongoose models for MongoDB.
- **/routes:** Express.js API routes.
- **/controllers:** Controller logic for API routes.

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/your-feature`).
6. Open a pull request.

## License

This project is licensed under the MIT License.

## Contact

For any questions or feedback, please contact [jaspal007](https://github.com/jaspal007).

---

This README provides a comprehensive overview of the project, including installation, usage, contribution guidelines, and more.
