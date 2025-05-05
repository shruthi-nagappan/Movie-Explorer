# 🎬 Movie Explorer

A feature-rich web application for discovering, exploring, and organizing movies with a beautiful, responsive interface.

## 📋 Overview

Movie Explorer is an interactive platform built with Streamlit and MySQL that allows users to browse movies, create watchlists, rate films, and explore movie analytics. The application features a modern dark-themed UI with comprehensive movie information including cast, crew, ratings, and more.

## ✨ Features

- **Movie Discovery**
  - Search by title or plot keywords
  - Filter by genre, release year, and studio
  - Grid-based movie browsing with visual cards

- **Detailed Movie Information**
  - Comprehensive movie details (plot, runtime, release date)
  - Cast and crew information
  - User ratings and reviews
  - Rating distribution visualization

- **Personal Watchlists**
  - Create multiple custom watchlists
  - Add/remove movies from watchlists
  - View all watchlists and their contents

- **Movie Analytics**
  - Visualize movie distribution by genre
  - Analyze rating trends
  - Track movie releases by year
  - Compare runtimes across genres
  - Discover top-rated movies

## 🛠️ Technologies Used

- **Frontend:** Streamlit
- **Backend:** Python, MySQL
- **Data Visualization:** Matplotlib, Seaborn
- **Database Connector:** MySQL Connector Python

## 📦 Installation

### Prerequisites

- Python 3.7+
- MySQL Server (MAMP or similar for local development)
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/movie-explorer.git
   cd movie-explorer
   ```

2. **Create a virtual environment (optional but recommended)**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up the MySQL database**
   - Start your MySQL server (via MAMP or similar)
   - Create a database named 'adt'
   - Update the database connection parameters in the code if needed:
     ```python
     conn = mysql.connector.connect(
         host="127.0.0.1",
         database="adt",
         user="root",
         password="root",
         port=8889
     )
     ```

5. **Prepare the SQL file**
   - Ensure the SQL file is in the correct location or update the path in the code:
     ```python
     sql_file_path = "/path/to/your/adtprojectpart2.sql"
     ```

6. **Run the application**
   ```bash
   streamlit run movie_explorer.py
   ```

## 🧭 Usage Guide

### Browsing Movies
- Use the search bar to find specific movies
- Apply filters to narrow your search by genre, year, or studio
- Click on "View Details" to see comprehensive information about a movie

### Managing Watchlists
- Navigate to "My Watchlists" in the sidebar
- Create a new watchlist by entering a name and clicking "Create Watchlist"
- Add movies to your watchlists from the movie details page
- View and manage your watchlist contents

### Rating Movies
- Rate movies on a scale of 1-10
- Write optional reviews to share your thoughts
- View average ratings and rating distributions

### Exploring Analytics
- Navigate to "Movie Analytics" in the sidebar
- Explore various charts and visualizations about the movie database
- Discover trends in genres, ratings, and release years

## 📁 Project Structure

```
movie-explorer/
├── movie_explorer.py     # Main application file
├── adtprojectpart2.sql   # SQL file for database initialization
├── README.md             # Project documentation
└── .gitignore            # Git ignore file
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🔮 Future Enhancements

- User authentication system
- Movie recommendation engine
- Social sharing features
- Advanced search capabilities
- Mobile application version
- Cloud deployment

⭐️ If you found this project interesting, please consider giving it a star!
