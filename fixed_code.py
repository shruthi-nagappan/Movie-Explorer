import streamlit as st
import pandas as pd
import mysql.connector  # MySQL adapter
import datetime
import re
import os
from PIL import Image
import requests
from io import BytesIO
import matplotlib.pyplot as plt
import seaborn as sns
import base64
from pathlib import Path


# Set page configuration
st.set_page_config(
    page_title="Movie Explorer App",
    page_icon="🎬",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Apply custom CSS for better appearance
def apply_custom_css():
    # Custom CSS to improve appearance
    st.markdown("""
    <style>
    /* Main background */
    .stApp {
        background-color: #0e1117;
        color: #FFFFFF;
    }
    
    /* Sidebar styling */
    .css-1d391kg {
        background-color: #1a1c24;
    }
    
    /* Headers */
    h1, h2, h3, h4 {
        color: #FF5733;
        font-family: 'Montserrat', sans-serif;
    }
    
    /* Buttons */
    .stButton>button {
        background-color: #FF5733;
        color: white;
        border-radius: 5px;
        border: none;
        font-weight: bold;
        padding: 10px 15px;
        margin: 5px 0px;
    }
    
    .stButton>button:hover {
        background-color: #E64A19;
    }
    
    /* Cards for movies */
    .movie-card {
        background-color: #1a1c24;
        border-radius: 10px;
        padding: 15px;
        margin-bottom: 15px;
        border: 1px solid #2c2e36;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .movie-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.2);
    }
    
    /* Custom tabs styling */
    .stTabs [data-baseweb="tab-list"] {
        gap: 2px;
        border-radius: 15px;
    }

    .stTabs [data-baseweb="tab"] {
        background-color: #1a1c24;
        border-radius: 15px 15px 0px 0px;
        padding: 10px 20px;
        border: 1px solid #2c2e36;
        border-bottom: none;
    }

    .stTabs [aria-selected="true"] {
        background-color: #FF5733;
        color: white;
    }
    
    /* Rating stars */
    .rating-stars {
        color: #FFD700;
        font-size: 18px;
    }
    
    /* Search box */
    .stTextInput>div>div>input {
        background-color: #2c2e36;
        color: white;
        border-radius: 5px;
    }
    
    /* Selectbox */
    .stSelectbox>div>div>div {
        background-color: #2c2e36;
        color: white;
        border-radius: 5px;
    }
    
    /* Divider */
    hr {
        margin: 20px 0px;
        border-color: #2c2e36;
    }
    
    /* Custom badge for genres */
    .genre-badge {
        background-color: #FF5733;
        padding: 3px 8px;
        border-radius: 12px;
        color: white;
        font-size: 12px;
        margin-right: 5px;
        display: inline-block;
    }
    
    /* Poster shadow */
    .poster-shadow img {
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        border-radius: 8px;
    }
    
    </style>
    """, unsafe_allow_html=True)

# Apply the CSS
apply_custom_css()

def ensure_default_user():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        # Check if the default user exists
        cursor.execute("SELECT 1 FROM Users WHERE UserID = 'U001'")
        user_exists = cursor.fetchone()
        
        if not user_exists:
            # Create default user if it doesn't exist
            cursor.execute(
                "INSERT INTO Users (UserID, Username, Email, PasswordHash, RegistrationDate) VALUES (%s, %s, %s, %s, CURRENT_TIMESTAMP)",
                ('U001', 'DefaultUser', 'default@example.com', 'placeholder_hash')
            )
            conn.commit()
            print("Created default user U001")
        
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Error ensuring default user: {str(e)}")
        return False
    
# Database connection function
def get_connection():
    # MySQL connection parameters - adjust these to your settings
    conn = mysql.connector.connect(
        host="127.0.0.1",  # or your MySQL server address
        database="adt",
        user="root",  # default MySQL user, change if different
        password="root",  # your MySQL password
        port=8889  # default MySQL port
    )
    return conn

# Function to create the database if it doesn't exist
def create_database():
    try:
        # Try to connect to the database
        conn = get_connection()
        cursor = conn.cursor()
        cursor.close()
        conn.close()
    except mysql.connector.Error as e:
        # If database doesn't exist, create it
        if "Unknown database" in str(e):
            # Connect to MySQL server without database specified
            admin_conn = mysql.connector.connect(
                host="localhost",
                user="root",
                password="root",
                port=8889
            )
            admin_cursor = admin_conn.cursor()
            
            # Create the database
            admin_cursor.execute("CREATE DATABASE adtproject;")
            admin_cursor.close()
            admin_conn.close()
            print("Database 'adtproject' created successfully")

# Initialize the database
create_database()

# Function to generate unique IDs
def generate_id(prefix, length=10):
    import uuid
    return f"{prefix}{str(uuid.uuid4())[:length-len(prefix)]}"

# Function to execute SQL statements from file
def execute_sql_file():
    conn = get_connection()
    cursor = conn.cursor()
    
    # Check if movies already exist - first check if table exists
    try:
        cursor.execute("SELECT COUNT(*) FROM Movies")
        row = cursor.fetchone()
        if row[0] > 0:
            cursor.close()
            conn.close()
            return False
    except mysql.connector.Error as e:
        # Table doesn't exist, we should create it
        pass
    
    try:
        # Load SQL statements from file
        sql_file_path = "/Users/shruthinagappan/Downloads/adtprojectpart2.sql"  # Path to your SQL file
        
        if os.path.exists(sql_file_path):
            with open(sql_file_path, 'r') as file:
                sql_content = file.read()
                
                # MySQL prefers each statement to be executed separately
                # MySQL uses a different delimiter syntax than PostgreSQL
                # Split by semicolons but keep in mind some statements might have semicolons in quotes
                sql_statements = []
                current_statement = ""
                
                for line in sql_content.split('\n'):
                    line = line.strip()
                    if line and not line.startswith('--'):  # Skip comments
                        current_statement += " " + line
                        if line.endswith(';'):
                            sql_statements.append(current_statement.strip())
                            current_statement = ""
                
                # Execute each statement
                for statement in sql_statements:
                    if statement.strip():  # Skip empty statements
                        try:
                            cursor.execute(statement)
                            conn.commit()  # Commit after each statement
                        except Exception as e:
                            print(f"Error executing: {statement[:100]}...")
                            print(f"Error details: {e}")
                            conn.rollback()  # Rollback on error
            
            cursor.close()
            conn.close()
            return True
        else:
            print(f"SQL file not found: {sql_file_path}")
            cursor.close()
            conn.close()
            return False
            
    except Exception as e:
        print(f"Error executing SQL: {e}")
        conn.rollback()
        cursor.close()
        conn.close()
        return False

# Initialize database with sample data if needed
def ensure_initial_data():
    # Execute SQL to create database and insert sample data
    execute_sql_file()



# Movie search and filters
def search_movies(search_term="", genre=None, release_year=None, studio=None):
    conn = get_connection()
    cursor = conn.cursor()
    
    # Modified query to properly join with ratings table
    query = """
    SELECT m.MovieID, m.Title, m.ReleaseDate, m.Runtime, m.PosterURL, 
           IFNULL(AVG(r.Score), 0) as AvgRating, 
           COUNT(r.RatingID) as RatingCount
    FROM Movies m
    LEFT JOIN Ratings r ON m.MovieID = r.MovieID
    LEFT JOIN Movie_Genres mg ON m.MovieID = mg.MovieID
    LEFT JOIN Genres g ON mg.GenreID = g.GenreID
    LEFT JOIN Movie_Studios ms ON m.MovieID = ms.MovieID
    LEFT JOIN Studios s ON ms.StudioID = s.StudioID
    WHERE 1=1
    """
    
    params = []
    
    if search_term:
        query += " AND (m.Title LIKE %s OR m.Plot LIKE %s)"
        params.extend([f"%{search_term}%", f"%{search_term}%"])
    
    if genre:
        query += " AND g.GenreName = %s"
        params.append(genre)
    
    if release_year:
        query += " AND YEAR(m.ReleaseDate) = %s"
        params.append(str(release_year))
    
    if studio:
        query += " AND s.StudioName = %s"
        params.append(studio)
    
    query += " GROUP BY m.MovieID ORDER BY m.ReleaseDate DESC LIMIT 100"
    
    cursor.execute(query, params)
    movies = cursor.fetchall()
    
    conn.close()
    return movies
    
    # Debug print to see if we're getting ratings
    if len(movies) > 0:
        print(f"Debug: First movie has rating: {movies[0][5]}, review count: {movies[0][6]}")
    
    conn.close()
    return movies

# Function to get movie details
def get_movie_details(movie_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # Use dictionary cursor for MySQL
    
    # Get movie info with ratings
    cursor.execute("""
    SELECT m.*, IFNULL(AVG(r.Score), 0) as AvgRating, COUNT(r.RatingID) as RatingCount
    FROM Movies m
    LEFT JOIN Ratings r ON m.MovieID = r.MovieID
    WHERE m.MovieID = %s
    GROUP BY m.MovieID
    """, (movie_id,))
    movie = cursor.fetchone()
    
    if not movie:
        cursor.close()
        conn.close()
        return None
    
    # Get genres
    cursor.execute("""
    SELECT g.GenreName
    FROM Movie_Genres mg
    JOIN Genres g ON mg.GenreID = g.GenreID
    WHERE mg.MovieID = %s
    """, (movie_id,))
    genres = [row['GenreName'] for row in cursor.fetchall()]
    
    # Get studios
    cursor.execute("""
    SELECT s.StudioName
    FROM Movie_Studios ms
    JOIN Studios s ON ms.StudioID = s.StudioID
    WHERE ms.MovieID = %s
    """, (movie_id,))
    studios = [row['StudioName'] for row in cursor.fetchall()]
    
    # Get cast - removed the ORDER BY that was causing errors
    cursor.execute("""
    SELECT p.Name, mc.CharacterName
    FROM Movie_Cast mc
    JOIN Persons p ON mc.PersonID = p.PersonID
    WHERE mc.MovieID = %s
    LIMIT 15
    """, (movie_id,))
    cast = cursor.fetchall()
    
    # Get crew
    cursor.execute("""
    SELECT p.Name, mc.Role
    FROM Movie_Crew mc
    JOIN Persons p ON mc.PersonID = p.PersonID
    WHERE mc.MovieID = %s
    """, (movie_id,))
    crew = cursor.fetchall()
    
    # Get specific reviews for this movie
    cursor.execute("""
    SELECT r.Score, r.Review, r.Timestamp, u.Username
    FROM Ratings r
    JOIN Users u ON r.UserID = u.UserID
    WHERE r.MovieID = %s
    ORDER BY r.Timestamp DESC
    LIMIT 10
    """, (movie_id,))
    reviews = cursor.fetchall()
    
    # Get rating distribution for this movie
    cursor.execute("""
    SELECT FLOOR(Score/2)*2 as ScoreRange, COUNT(*) as Count
    FROM Ratings
    WHERE MovieID = %s
    GROUP BY ScoreRange
    ORDER BY ScoreRange
    """, (movie_id,))
    rating_distribution = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return {
        'movie': movie,
        'genres': genres,
        'studios': studios,
        'cast': cast,
        'crew': crew,
        'reviews': reviews,
        'rating_distribution': rating_distribution
    }

# Modified function for adding ratings - now doesn't actually store anything
def add_rating(movie_id, score, review=""):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        # Use default user for all ratings
        user_id = 'U001'
        
        # Check if user has already rated this movie
        cursor.execute("SELECT RatingID FROM Ratings WHERE MovieID = %s AND UserID = %s", (movie_id, user_id))
        existing_rating = cursor.fetchone()
        
        if existing_rating:
            # Update existing rating
            cursor.execute(
                "UPDATE Ratings SET Score = %s, Review = %s, Timestamp = CURRENT_TIMESTAMP WHERE MovieID = %s AND UserID = %s",
                (score, review, movie_id, user_id)
            )
            message = "Rating updated successfully!"
        else:
            # Create new rating
            rating_id = generate_id('R')
            cursor.execute(
                "INSERT INTO Ratings (RatingID, MovieID, UserID, Score, Review) VALUES (%s, %s, %s, %s, %s)",
                (rating_id, movie_id, user_id, score, review)
            )
            message = "Rating submitted successfully!"
        
        conn.commit()
        conn.close()
        return True, message
    except Exception as e:
        return False, f"Error submitting rating: {str(e)}"

# Function to get user watchlists
def get_user_watchlists():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # Use dictionary cursor
    
    # Use default user
    user_id = 'U001'
    
    cursor.execute("""
    SELECT WatchlistID, Name, CreatedDate, 
           (SELECT COUNT(*) FROM Watchlist_Movies wm WHERE wm.WatchlistID = w.WatchlistID) as MovieCount
    FROM Watchlists w
    WHERE UserID = %s
    ORDER BY CreatedDate DESC
    """, (user_id,))
    
    watchlists = cursor.fetchall()
    conn.close()
    
    return watchlists

# Function to create a watchlist
def create_watchlist(name):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        # Use default user
        user_id = 'U001'
        
        # First check if the user exists
        cursor.execute("SELECT 1 FROM Users WHERE UserID = %s", (user_id,))
        user_exists = cursor.fetchone()
        
        if not user_exists:
            # Create default user if it doesn't exist with the correct fields
            cursor.execute(
                """INSERT INTO Users (UserID, Username, Email, Password, JoinDate) 
                VALUES (%s, %s, %s, %s, CURRENT_TIMESTAMP)""",
                (user_id, 'DefaultUser', 'default@example.com', 'securePass123!')
            )
            conn.commit()
            print(f"Created default user {user_id}")
        
        # Now create the watchlist
        watchlist_id = generate_id('W')
        cursor.execute(
            """INSERT INTO Watchlists (WatchlistID, UserID, Name, CreatedDate) 
            VALUES (%s, %s, %s, CURRENT_TIMESTAMP)""",
            (watchlist_id, user_id, name)
        )
        
        conn.commit()
        cursor.close()
        conn.close()
        return True, watchlist_id
    except Exception as e:
        if 'conn' in locals():
            try:
                cursor.close()
            except:
                pass
            try:
                conn.close()
            except:
                pass
        return False, str(e)

# Function to add movie to watchlist
def add_to_watchlist(watchlist_id, movie_id):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        # Check if movie already in this watchlist
        cursor.execute("SELECT 1 FROM Watchlist_Movies WHERE WatchlistID = %s AND MovieID = %s", (watchlist_id, movie_id))
        if cursor.fetchone():
            conn.close()
            return False, "Movie already in this watchlist."
        
        cursor.execute(
            "INSERT INTO Watchlist_Movies (WatchlistID, MovieID) VALUES (%s, %s)",
            (watchlist_id, movie_id)
        )
        
        conn.commit()
        conn.close()
        return True, "Movie added to watchlist."
    except Exception as e:
        return False, f"Error adding to watchlist: {str(e)}"

# Function to remove movie from watchlist
def remove_from_watchlist(watchlist_id, movie_id):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        cursor.execute(
            "DELETE FROM Watchlist_Movies WHERE WatchlistID = %s AND MovieID = %s",
            (watchlist_id, movie_id)
        )
        
        conn.commit()
        conn.close()
        return True, "Movie removed from watchlist."
    except Exception as e:
        return False, f"Error removing from watchlist: {str(e)}"

# Function to get watchlist details with movies
def get_watchlist_details(watchlist_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # Use dictionary cursor
    
    # Get watchlist info
    cursor.execute("SELECT * FROM Watchlists WHERE WatchlistID = %s", (watchlist_id,))
    watchlist = cursor.fetchone()
    
    if not watchlist:
        conn.close()
        return None
    
    # Get movies in watchlist
    cursor.execute("""
    SELECT m.MovieID, m.Title, m.ReleaseDate, m.PosterURL, wm.AddedDate
    FROM Watchlist_Movies wm
    JOIN Movies m ON wm.MovieID = m.MovieID
    WHERE wm.WatchlistID = %s
    ORDER BY wm.AddedDate DESC
    """, (watchlist_id,))
    
    movies = cursor.fetchall()
    conn.close()
    
    return {
        'watchlist': watchlist,
        'movies': movies
    }

# Function to get genres for filters
def get_all_genres():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # Use dictionary cursor
    cursor.execute("SELECT GenreName FROM Genres ORDER BY GenreName")
    genres = [row['GenreName'] for row in cursor.fetchall()]
    conn.close()
    return genres

# Function to get studios for filters
def get_all_studios():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # Use dictionary cursor
    cursor.execute("SELECT StudioName FROM Studios ORDER BY StudioName")
    studios = [row['StudioName'] for row in cursor.fetchall()]
    conn.close()
    return studios

# Function to get release years for filters
def get_release_years():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # Use dictionary cursor
    cursor.execute("SELECT DISTINCT YEAR(ReleaseDate) as Year FROM Movies ORDER BY Year DESC")  # Changed strftime to YEAR
    years = [row['Year'] for row in cursor.fetchall()]
    conn.close()
    return years


def ensure_test_ratings():
    """Add some test ratings to the database if none exist"""
    conn = get_connection()
    cursor = conn.cursor()
    
    # Check if any ratings exist
    cursor.execute("SELECT COUNT(*) FROM Ratings")
    count = cursor.fetchone()[0]
    
    if count == 0:
        print("No ratings found, adding test ratings...")
        # Get some random movies to add ratings to
        cursor.execute("SELECT MovieID FROM Movies LIMIT 10")
        movies = [row[0] for row in cursor.fetchall()]
        
        # Use default user
        user_id = 'U001'
        
        # Add some test ratings
        for i, movie_id in enumerate(movies):
            rating_id = f"R{i+1:03d}"  # Generate rating ID
            score = (i % 10) + 1  # Ratings 1-10
            review = f"Test review {i+1} for movie {movie_id}"
            
            try:
                cursor.execute(
                    "INSERT INTO Ratings (RatingID, MovieID, UserID, Score, Review) VALUES (%s, %s, %s, %s, %s)",
                    (rating_id, movie_id, user_id, score, review)
                )
                print(f"Added test rating {rating_id} for movie {movie_id}")
            except Exception as e:
                print(f"Error adding test rating: {e}")
        
        conn.commit()
    
    cursor.close()
    conn.close()
    
# Main App
def main():
    # Ensure we have initial data
    ensure_initial_data()

    # Make sure the default user exists
    ensure_default_user()

    ensure_test_ratings()
    
    # App header with logo
    st.markdown("""
    <div style="display: flex; align-items: center; margin-bottom: 20px; background-color: #1a1c24; padding: 15px; border-radius: 10px;">
        <h1 style="margin: 0; color: #FF5733; font-family: 'Montserrat', sans-serif;">🎬 Movie Explorer</h1>
    </div>
    """, unsafe_allow_html=True)
    
    # Sidebar navigation
    st.sidebar.markdown("""
    <div style="text-align: center; margin-bottom: 20px;">
        <h2 style="color: #FF5733; font-family: 'Montserrat', sans-serif;">Navigation</h2>
    </div>
    """, unsafe_allow_html=True)
    
    # Navigation options with custom styling
    nav_options = ["Browse Movies", "My Watchlists", "Movie Analytics"]
    
    # Create styled radio buttons
    nav_option = st.sidebar.radio("", nav_options, index=0)
    
    # Add spacer
    st.sidebar.markdown("<hr>", unsafe_allow_html=True)
    
    # Add app info
    st.sidebar.markdown("""
    <div style="text-align: center; margin-top: 30px; padding: 15px; background-color: #2c2e36; border-radius: 10px;">
        <h3 style="color: #FF5733;">About</h3>
        <p>Movie Explorer helps you discover, track, and organize your favorite films.</p>
        <p style="font-size: 12px; color: #888;">Version 1.0</p>
    </div>
    """, unsafe_allow_html=True)
    
    # Display selected page
    if nav_option == "Browse Movies":
        browse_movies_page()
    elif nav_option == "My Watchlists":
        watchlists_page()
    elif nav_option == "Movie Analytics":
        movie_analytics_page()
        

# Browse Movies Page
# Updated movie_card function using display_movie_rating
def movie_card(movie, col):
    with col:
        st.markdown(f'<div class="movie-card">', unsafe_allow_html=True)
        
        
        # Movie title and year
        # Check if ReleaseDate is already a date object (from MySQL) or a string (needs conversion)
        if movie[2]:
            if isinstance(movie[2], str):
                release_year = datetime.datetime.strptime(movie[2], '%Y-%m-%d').year
            else:
                # It's already a date object
                release_year = movie[2].year
        else:
            release_year = "Unknown"
            
        st.markdown(f"<h3 style='margin-bottom:0px; font-size:18px;'>{movie[1]} ({release_year})</h3>", unsafe_allow_html=True)
        
        # Convert movie tuple to dictionary for consistent display format
        movie_dict = {
            'AvgRating': movie[5],
            'RatingCount': movie[6]
        }
        
        # Display rating using the consistent display_movie_rating function
        display_movie_rating_in_card(movie_dict)
        
        # Action buttons - Rate and Add to Watchlist in two columns
        col1, col2 = st.columns(2)
        
        with col1:
            # Rate button - using a unique key for each movie and each column
            unique_rate_key = f"rate_{movie[0]}_{col}"
            if st.button("⭐ Rate", key=unique_rate_key):
                st.session_state['movie_to_rate'] = movie[0]
                st.session_state['movie_to_rate_title'] = movie[1]
                st.rerun()
        
        with col2:
            # Add to Watchlist button - using a unique key for each movie and each column
            unique_watchlist_key = f"add_{movie[0]}_{col}"
            if st.button("+ Watchlist", key=unique_watchlist_key):
                st.session_state['add_to_watchlist_movie'] = movie[0]
                st.session_state['add_to_watchlist_title'] = movie[1]
                st.rerun()
        
        # View Details button
        unique_details_key = f"details_{movie[0]}_{col}"
        if st.button("🔍 View Details", key=unique_details_key):
            st.session_state['selected_movie'] = movie[0]
            st.rerun()
        
        st.markdown('</div>', unsafe_allow_html=True)

# Simplified function to display ratings in movie cards
def display_movie_rating_in_card(movie):
    if movie['AvgRating'] and float(movie['AvgRating']) > 0 and movie['RatingCount'] > 0:
        avg_rating = round(float(movie['AvgRating']), 1)
        full_stars = int(avg_rating / 2)
        half_star = avg_rating % 2 >= 1
        stars = "⭐" * full_stars
        if half_star:
            stars += "½"
            
        st.markdown(f"""
        <div style="margin-bottom: 10px;">
            <div style="font-size: 18px; color: gold; margin-bottom: 5px;">{stars}</div>
            <div><span style="color: #00FFFF; font-weight: bold;">{avg_rating}/10</span> ({movie['RatingCount']} reviews)</div>
        </div>
        """, unsafe_allow_html=True)
    else:
        st.markdown("<p>No ratings yet</p>", unsafe_allow_html=True)


# Update search_movies function to ensure we get ratings properly
def search_movies(search_term="", genre=None, release_year=None, studio=None):
    conn = get_connection()
    cursor = conn.cursor()
    
    # Modified query to properly join with ratings table and handle null values
    query = """
    SELECT m.MovieID, m.Title, m.ReleaseDate, m.Runtime, m.PosterURL, 
           IFNULL(AVG(r.Score), 0) as AvgRating, 
           COUNT(r.RatingID) as RatingCount
    FROM Movies m
    LEFT JOIN Ratings r ON m.MovieID = r.MovieID
    LEFT JOIN Movie_Genres mg ON m.MovieID = mg.MovieID
    LEFT JOIN Genres g ON mg.GenreID = g.GenreID
    LEFT JOIN Movie_Studios ms ON m.MovieID = ms.MovieID
    LEFT JOIN Studios s ON ms.StudioID = s.StudioID
    WHERE 1=1
    """
    
    params = []
    
    if search_term:
        query += " AND (m.Title LIKE %s OR m.Plot LIKE %s)"
        params.extend([f"%{search_term}%", f"%{search_term}%"])
    
    if genre:
        query += " AND g.GenreName = %s"
        params.append(genre)
    
    if release_year:
        query += " AND YEAR(m.ReleaseDate) = %s"
        params.append(str(release_year))
    
    if studio:
        query += " AND s.StudioName = %s"
        params.append(studio)
    
    query += " GROUP BY m.MovieID ORDER BY m.ReleaseDate DESC LIMIT 100"
    
    cursor.execute(query, params)
    movies = cursor.fetchall()
    
    conn.close()
    return movies
        
def display_movie_rating(movie):
    if movie['AvgRating'] and float(movie['AvgRating']) > 0 and movie['RatingCount'] > 0:
        avg_rating = round(float(movie['AvgRating']), 1)
        full_stars = int(avg_rating / 2)
        half_star = avg_rating % 2 >= 1
        stars = "⭐" * full_stars
        if half_star:
            stars += "½"
            
        st.markdown(f"""
        <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-top: 15px; text-align: center;">
            <h3 style="color: #FF5733; margin-top: 0; margin-bottom: 10px;">Rating</h3>
            <div style="font-size: 24px; color: gold; margin-bottom: 5px;">{stars}</div>
            <div style="font-size: 28px; font-weight: bold; color: #00FFFF;">{avg_rating}/10</div>
            <div style="color: #aaa; margin-top: 5px;">Based on {movie['RatingCount']} reviews</div>
        </div>
        """, unsafe_allow_html=True)
    else:
        st.markdown("""
        <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-top: 15px; text-align: center;">
            <h3 style="color: #FF5733; margin-top: 0;">Rating</h3>
            <div style="font-size: 16px;">No ratings yet</div>
        </div>
        """, unsafe_allow_html=True)

# Function to show movie details
def show_movie_details(movie_id):
    details = get_movie_details(movie_id)
    
    if not details:
        st.error("Movie not found.")
        st.session_state.pop('selected_movie', None)
        return
    
    movie = details['movie']
    
    # Create an overlay for movie details

    
    # Back button
    if st.button("← Back to movies", key="back_button"):
        st.session_state.pop('selected_movie', None)
        st.rerun()
    
    # Movie header with styled container
    st.markdown("""
    <div style="background-color: #1a1c24; padding: 30px; border-radius: 15px; margin: 20px 0; border: 1px solid #2c2e36;">
    """, unsafe_allow_html=True)
    
    col1, col2 = st.columns([1, 3])
    
    with col1:
        # Poster with shadow
        st.markdown('<div class="poster-shadow">', unsafe_allow_html=True)
        poster_url = movie['PosterURL']
        if poster_url:
            if poster_url.startswith('http'):
                try:
                    response = requests.get(poster_url)
                    img = Image.open(BytesIO(response.content))
                    st.image(img, width=250)
                except:
                    st.image("https://via.placeholder.com/250x375?text=No+Image", width=250)
            else:
                # For relative paths like '/posters/inception.jpg'
                st.image("https://via.placeholder.com/250x375?text=Poster+Available", width=250)
        else:
            st.image("https://via.placeholder.com/250x375?text=No+Image", width=250)
        st.markdown('</div>', unsafe_allow_html=True)
        
        # Display rating in a more prominent way
        if movie['AvgRating']:
            avg_rating = round(movie['AvgRating'], 1)
            full_stars = int(avg_rating / 2)
            half_star = avg_rating % 2 >= 1
            stars = "⭐" * full_stars
            if half_star:
                stars += "½"
                
            st.markdown(f"""
            <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-top: 15px; text-align: center;">
                <h3 style="color: #FF5733; margin-top: 0; margin-bottom: 10px;">Rating</h3>
                <div style="font-size: 24px; color: gold; margin-bottom: 5px;">{stars}</div>
                <div style="font-size: 28px; font-weight: bold; color: #00FFFF;">{avg_rating}/10</div>
                <div style="color: #aaa; margin-top: 5px;">Based on {movie['RatingCount']} reviews</div>
            </div>
            """, unsafe_allow_html=True)
        else:
            st.markdown("""
            <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-top: 15px; text-align: center;">
                <h3 style="color: #FF5733; margin-top: 0;">Rating</h3>
                <div style="font-size: 16px;">No ratings yet</div>
            </div>
            """, unsafe_allow_html=True)
    
    with col2:
        # Movie title and year
        # Check if ReleaseDate is already a date object or a string
        if movie['ReleaseDate']:
            if isinstance(movie['ReleaseDate'], str):
                release_year = datetime.datetime.strptime(movie['ReleaseDate'], '%Y-%m-%d').year
            else:
                # It's already a date object
                release_year = movie['ReleaseDate'].year
        else:
            release_year = "Unknown"
            
        st.markdown(f"<h1 style='color: #FF5733; margin-bottom: 5px;'>{movie['Title']} ({release_year})</h1>", unsafe_allow_html=True)
        
        # Genre badges
        if details['genres']:
            genre_badges = ""
            for genre in details['genres']:
                genre_badges += f"<span class='genre-badge'>{genre}</span>"
            st.markdown(f"<div style='margin-bottom: 15px;'>{genre_badges}</div>", unsafe_allow_html=True)
        
        # Runtime
        runtime_hours = movie['Runtime'] // 60
        runtime_minutes = movie['Runtime'] % 60
        runtime_str = f"{runtime_hours}h {runtime_minutes}m" if runtime_hours > 0 else f"{runtime_minutes}m"
        st.markdown(f"<p><strong style='color: #00FFFF;'>Runtime:</strong> {runtime_str}</p>", unsafe_allow_html=True)
        
        # Release date
        st.markdown(f"<p><strong style='color: #00FFFF;'>Release Date:</strong> {movie['ReleaseDate']}</p>", unsafe_allow_html=True)
        
        # Studios
        if details['studios']:
            st.markdown(f"<p><strong style='color: #00FFFF;'>Studios:</strong> {', '.join(details['studios'])}</p>", unsafe_allow_html=True)
        
        # Budget and Revenue
        if movie['Budget']:
            st.markdown(f"<p><strong style='color: #00FFFF;'>Budget:</strong> ${movie['Budget']:,}</p>", unsafe_allow_html=True)
        
        if movie['Revenue']:
            st.markdown(f"<p><strong style='color: #00FFFF;'>Revenue:</strong> ${movie['Revenue']:,}</p>", unsafe_allow_html=True)
            
        # Plot
        if movie['Plot']:
            st.markdown(f"<div style='background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-top: 20px;'><strong style='color: #00FFFF;'>Plot:</strong> {movie['Plot']}</div>", unsafe_allow_html=True)
    
    st.markdown("</div>", unsafe_allow_html=True)
    
    # Cast, Crew, Reviews, and Watchlist tabs with custom styling
    tab1, tab2, tab3, tab4 = st.tabs(["Cast", "Crew", "Reviews", "Add to Watchlist"])
    
    with tab1:
        if details['cast']:
            st.markdown("<div style='background-color: #1a1c24; padding: 20px; border-radius: 10px; margin-top: 20px; border: 1px solid #2c2e36;'>", unsafe_allow_html=True)
            st.markdown("<h3 style='color: #FF5733; margin-top: 0;'>Cast</h3>", unsafe_allow_html=True)
            
            # Display cast in a more appealing way
            cast_cols = st.columns(3)
            for i, actor in enumerate(details['cast']):
                with cast_cols[i % 3]:
                    st.markdown(f"""
                    <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-bottom: 15px;">
                        <h4 style="margin: 0; color: #FF5733;">{actor['Name']}</h4>
                        <p style="margin: 5px 0 0 0;">as {actor['CharacterName']}</p>
                    </div>
                    """, unsafe_allow_html=True)
            
            st.markdown("</div>", unsafe_allow_html=True)
        else:
            st.info("No cast information available.")
    
    with tab2:
        if details['crew']:
            st.markdown("<div style='background-color: #1a1c24; padding: 20px; border-radius: 10px; margin-top: 20px; border: 1px solid #2c2e36;'>", unsafe_allow_html=True)
            st.markdown("<h3 style='color: #FF5733; margin-top: 0;'>Crew</h3>", unsafe_allow_html=True)
            
            # Group crew by role
            crew_by_role = {}
            for crew_member in details['crew']:
                role = crew_member['Role']
                if role not in crew_by_role:
                    crew_by_role[role] = []
                crew_by_role[role].append(crew_member['Name'])
            
            # Display crew grouped by role
            for role, members in crew_by_role.items():
                st.markdown(f"""
                <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-bottom: 15px;">
                    <h4 style="margin: 0; color: #FF5733;">{role}</h4>
                    <p style="margin: 5px 0 0 0;">{', '.join(members)}</p>
                </div>
                """, unsafe_allow_html=True)
            
            st.markdown("</div>", unsafe_allow_html=True)
        else:
            st.info("No crew information available.")
    
    with tab3:
        st.markdown("<div style='background-color: #1a1c24; padding: 20px; border-radius: 10px; margin-top: 20px; border: 1px solid #2c2e36;'>", unsafe_allow_html=True)
        st.markdown("<h3 style='color: #FF5733; margin-top: 0;'>Reviews</h3>", unsafe_allow_html=True)
        
        # Display rating distribution if available
        if details['rating_distribution']:
            st.markdown("<h4 style='color: #00FFFF;'>Rating Distribution</h4>", unsafe_allow_html=True)
            
            # Create a horizontal bar chart for rating distribution
            score_ranges = []
            counts = []
            for dist in details['rating_distribution']:
                score_ranges.append(dist['ScoreRange'])
                counts.append(dist['Count'])
            
            if score_ranges and counts:
                # Create columns for rating visualization
                dist_cols = st.columns([3, 1])
                with dist_cols[0]:
                    # Create bar chart visualization
                    max_count = max(counts) if counts else 0
                    for i, (score_range, count) in enumerate(zip(score_ranges, counts)):
                        # Calculate percentage of the maximum for bar width
                        percentage = (count / max_count) * 100 if max_count > 0 else 0
                        st.markdown(f"""
                        <div style="display: flex; align-items: center; margin-bottom: 8px;">
                            <div style="width: 60px; text-align: right; margin-right: 10px;">{score_range}</div>
                            <div style="background-color: #FF5733; height: 18px; width: {percentage}%; border-radius: 4px;"></div>
                            <div style="margin-left: 10px;">{count}</div>
                        </div>
                        """, unsafe_allow_html=True)
        
        # Show existing reviews
        if details['reviews']:
            st.markdown("<h4 style='color: #00FFFF; margin-top: 20px;'>User Reviews</h4>", unsafe_allow_html=True)
            
            for review in details['reviews']:
                # Create star rating display
                full_stars = int(review['Score'] / 2)
                half_star = review['Score'] % 2 >= 1
                stars = "⭐" * full_stars
                if half_star:
                    stars += "½"
                
                st.markdown(f"""
                <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin: 15px 0;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h4 style="margin: 0; color: #FF5733;">{review['Username']}</h4>
                        <div style="color: gold; font-size: 18px;">{stars} <span style="color: white;">{review['Score']}/10</span></div>
                    </div>
                    <p style="margin: 10px 0 5px 0;">{review['Review'] if review['Review'] else "No written review"}</p>
                    <p style="font-size: 12px; color: #888; margin: 0;">Posted on {review['Timestamp']}</p>
                </div>
                """, unsafe_allow_html=True)
        else:
            st.markdown("<p>No reviews yet.</p>", unsafe_allow_html=True)
        
        st.markdown("</div>", unsafe_allow_html=True)
    
    with tab4:
        st.markdown("<div style='background-color: #1a1c24; padding: 20px; border-radius: 10px; margin-top: 20px; border: 1px solid #2c2e36;'>", unsafe_allow_html=True)
        st.markdown("<h3 style='color: #FF5733; margin-top: 0;'>Add to Watchlist</h3>", unsafe_allow_html=True)
        
        # Show available watchlists
        watchlists = get_user_watchlists()
        
        if not watchlists:
            st.markdown("<p>You don't have any watchlists yet.</p>", unsafe_allow_html=True)
            
            # Create new watchlist
            with st.form(key="create_watchlist"):
                st.markdown("<h4 style='color: #FF5733;'>Create a new watchlist</h4>", unsafe_allow_html=True)
                watchlist_name = st.text_input("Watchlist Name")
                create_button = st.form_submit_button("Create Watchlist")
                
                if create_button and watchlist_name:
                    success, watchlist_id = create_watchlist(watchlist_name)
                    if success:
                        st.success(f"Watchlist '{watchlist_name}' created!")
                        # Add movie to the new watchlist
                        add_to_watchlist(watchlist_id, movie_id)
                        st.success(f"Added '{movie['Title']}' to '{watchlist_name}'")
                        st.rerun()
                    else:
                        st.error(f"Error creating watchlist: {watchlist_id}")
        else:
            st.markdown("<p>Select a watchlist to add this movie:</p>", unsafe_allow_html=True)
            
            # Display watchlists as cards
            for watchlist in watchlists:
                col1, col2 = st.columns([3, 1])
                
                with col1:
                    st.markdown(f"""
                    <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin-bottom: 10px;">
                        <h4 style="margin: 0; color: #FF5733;">{watchlist['Name']}</h4>
                        <p style="margin: 5px 0 0 0;">{watchlist['MovieCount']} movies</p>
                    </div>
                    """, unsafe_allow_html=True)
                
                with col2:
                    if st.button(f"Add", key=f"add_{watchlist['WatchlistID']}"):
                        success, message = add_to_watchlist(watchlist['WatchlistID'], movie_id)
                        if success:
                            st.success(message)
                        else:
                            st.error(message)
            
            # Option to create a new watchlist
            with st.expander("Create New Watchlist"):
                with st.form(key="create_watchlist_existing"):
                    st.markdown("<h4 style='color: #FF5733;'>Create a new watchlist</h4>", unsafe_allow_html=True)
                    watchlist_name = st.text_input("Watchlist Name")
                    create_button = st.form_submit_button("Create & Add Movie")
                    
                    if create_button and watchlist_name:
                        success, watchlist_id = create_watchlist(watchlist_name)
                        if success:
                            add_to_watchlist(watchlist_id, movie_id)
                            st.success(f"Added '{movie['Title']}' to new watchlist '{watchlist_name}'")
                            st.rerun()
                        else:
                            st.error(f"Error creating watchlist: {watchlist_id}")
        
        st.markdown("</div>", unsafe_allow_html=True)
    
    # Close the overlay div
    st.markdown("</div>", unsafe_allow_html=True)
    

# Browse Movies Page
def browse_movies_page():
    st.markdown("<h2 style='color: #FF5733;'>Browse Movies</h2>", unsafe_allow_html=True)
    
    # If a movie is selected, show its details
    if 'selected_movie' in st.session_state:
        show_movie_details(st.session_state['selected_movie'])
    
    # Check if we need to show the rating dialog
    if 'movie_to_rate' in st.session_state:
        movie_id = st.session_state['movie_to_rate']
        movie_title = st.session_state['movie_to_rate_title']
        
        st.sidebar.markdown(f"<h3 style='color: #FF5733;'>Rate '{movie_title}'</h3>", unsafe_allow_html=True)
        st.sidebar.markdown("<p style='color: #00FFFF;'><i>Note: Ratings are for display only and are not stored or used in this demo.</i></p>", unsafe_allow_html=True)
        
        with st.sidebar.form(key="rate_movie_form"):
            score = st.slider("Your Rating", 1, 10, 5)
            review = st.text_area("Your Review (optional)")
            submit_button = st.form_submit_button("Submit Rating")
            
            if submit_button:
                success, message = add_rating(movie_id, score, review)
                if success:
                    st.sidebar.success(message)
                    # Remove from session state after successful rating
                    st.session_state.pop('movie_to_rate', None)
                    st.session_state.pop('movie_to_rate_title', None)
                    st.rerun()
                else:
                    st.sidebar.error(message)
        
        # Cancel button
        if st.sidebar.button("Cancel Rating"):
            st.session_state.pop('movie_to_rate', None)
            st.session_state.pop('movie_to_rate_title', None)
            st.rerun()
    
    # Check if we need to show the add to watchlist dialog
    if 'add_to_watchlist_movie' in st.session_state:
        movie_id = st.session_state['add_to_watchlist_movie']
        movie_title = st.session_state['add_to_watchlist_title']
        
        st.sidebar.markdown(f"<h3 style='color: #FF5733;'>Add '{movie_title}' to Watchlist</h3>", unsafe_allow_html=True)
        
        # Get watchlists
        watchlists = get_user_watchlists()
        
        if watchlists:
            st.sidebar.markdown("<p>Select a watchlist:</p>", unsafe_allow_html=True)
            
            for watchlist in watchlists:
                if st.sidebar.button(f"{watchlist['Name']} ({watchlist['MovieCount']} movies)", key=f"select_wl_{watchlist['WatchlistID']}"):
                    success, message = add_to_watchlist(watchlist['WatchlistID'], movie_id)
                    if success:
                        st.sidebar.success(f"Added to '{watchlist['Name']}' watchlist!")
                        # Remove from session state after successful addition
                        st.session_state.pop('add_to_watchlist_movie', None)
                        st.session_state.pop('add_to_watchlist_title', None)
                        st.rerun()
                    else:
                        st.sidebar.error(message)
        
        # Option to create a new watchlist
        st.sidebar.markdown("<h4 style='color: #FF5733;'>Or create new watchlist:</h4>", unsafe_allow_html=True)
        
        with st.sidebar.form(key="create_wl_form"):
            watchlist_name = st.text_input("Watchlist Name")
            create_button = st.form_submit_button("Create & Add")
            
            if create_button and watchlist_name:
                success, watchlist_id = create_watchlist(watchlist_name)
                if success:
                    add_success, add_message = add_to_watchlist(watchlist_id, movie_id)
                    if add_success:
                        st.sidebar.success(f"Created watchlist '{watchlist_name}' and added movie!")
                        # Remove from session state after successful addition
                        st.session_state.pop('add_to_watchlist_movie', None)
                        st.session_state.pop('add_to_watchlist_title', None)
                        st.rerun()
                    else:
                        st.sidebar.error(f"Created watchlist but failed to add movie: {add_message}")
                else:
                    st.sidebar.error(f"Error creating watchlist: {watchlist_id}")
        
        # Cancel button
        if st.sidebar.button("Cancel"):
            st.session_state.pop('add_to_watchlist_movie', None)
            st.session_state.pop('add_to_watchlist_title', None)
            st.rerun()
    
    # Search and filters in a styled card with brighter text
    st.markdown("""
    <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin-bottom: 30px; border: 1px solid #2c2e36;">
        <h3 style="color: #FF5733; margin-top: 0;">Search & Filter</h3>
        <p style="color: #00FFFF; font-weight: bold; font-size: 16px; margin-bottom: 5px;">Find your favorite movies using the filters below</p>
    </div>
    """, unsafe_allow_html=True)
    
    # Apply custom CSS to make labels brighter
    st.markdown("""
    <style>
    .bright-label {
        color: #00FFFF !important;
        font-weight: bold !important;
        font-size: 16px !important;
    }
    
    /* Override Streamlit's label styling */
    .stSelectbox label, .stTextInput label {
        color: #00FFFF !important;
        font-weight: bold !important;
        font-size: 16px !important;
    }
    
    /* Enhance rating stars display */
    .rating-stars {
        color: gold !important;
        font-size: 18px !important;
        margin-bottom: 5px !important;
    }
    </style>
    """, unsafe_allow_html=True)
    
    col1, col2, col3, col4 = st.columns([3, 1, 1, 1])
    
    with col1:
        st.markdown('<p class="bright-label">Search by title or plot</p>', unsafe_allow_html=True)
        search_term = st.text_input("", "", placeholder="Enter movie title or keywords...")
    
    with col2:
        st.markdown('<p class="bright-label">Genre</p>', unsafe_allow_html=True)
        genres = [""] + get_all_genres()
        selected_genre = st.selectbox("", genres)
    
    with col3:
        st.markdown('<p class="bright-label">Release Year</p>', unsafe_allow_html=True)
        years = [""] + get_release_years()
        selected_year = st.selectbox("", years)
    
    with col4:
        st.markdown('<p class="bright-label">Studio</p>', unsafe_allow_html=True)
        studios = [""] + get_all_studios()
        selected_studio = st.selectbox("", studios)
    
    genre_filter = selected_genre if selected_genre else None
    year_filter = selected_year if selected_year else None
    studio_filter = selected_studio if selected_studio else None
    
    # Get movies based on filters - this now includes ratings from the database
    movies = search_movies(search_term, genre_filter, year_filter, studio_filter)
    
    if not movies:
        st.info("No movies found matching your criteria.")
        return
    
    # Display results count
    st.markdown(f"<h3 style='color: #FF5733; margin-top: 30px;'>Found {len(movies)} movies</h3>", unsafe_allow_html=True)
    
    # Display movies in a grid
    num_cols = 4
    for i in range(0, len(movies), num_cols):
        cols = st.columns(num_cols)
        for j in range(num_cols):
            if i + j < len(movies):
                movie_card(movies[i + j], cols[j])


# My Watchlists Page
def watchlists_page():
    st.markdown("<h2 style='color: #FF5733;'>My Watchlists</h2>", unsafe_allow_html=True)
    
    # Get user's watchlists
    watchlists = get_user_watchlists()
    
    # Create new watchlist section with styling
    st.markdown("""
    <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
        <h3 style="color: #FF5733; margin-top: 0;">Create New Watchlist</h3>
    </div>
    """, unsafe_allow_html=True)
    
    with st.form(key="create_watchlist_page"):
        watchlist_name = st.text_input("Watchlist Name", placeholder="Enter a name for your new watchlist...")
        create_button = st.form_submit_button("Create Watchlist")
        
        if create_button and watchlist_name:
            success, watchlist_id = create_watchlist(watchlist_name)
            if success:
                st.success(f"Watchlist '{watchlist_name}' created!")
                st.rerun()
            else:
                st.error(f"Error creating watchlist: {watchlist_id}")
    
    if not watchlists:
        st.markdown("""
        <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; text-align: center; border: 1px solid #2c2e36;">
            <h3 style="color: #FF5733;">No Watchlists Yet</h3>
            <p>Create your first watchlist to start organizing your favorite movies!</p>
        </div>
        """, unsafe_allow_html=True)
        return
    
    # Display watchlists
    st.markdown("""
    <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
        <h3 style="color: #FF5733; margin-top: 0;">Your Watchlists</h3>
    </div>
    """, unsafe_allow_html=True)
    
    # Display each watchlist as a card
    for watchlist in watchlists:
        st.markdown(f"""
        <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 10px 0; border: 1px solid #2c2e36;">
            <h3 style="color: #FF5733; margin-top: 0;">{watchlist['Name']}</h3>
            <p>Created: {watchlist['CreatedDate']}</p>
            <p>{watchlist['MovieCount']} movies</p>
        </div>
        """, unsafe_allow_html=True)
        
        # View contents button
        if 'selected_watchlist' in st.session_state and st.session_state['selected_watchlist'] == watchlist['WatchlistID']:
            if st.button("Hide Contents", key=f"hide_watchlist_{watchlist['WatchlistID']}"):
                st.session_state.pop('selected_watchlist', None)
                st.rerun()
            show_watchlist_details(watchlist['WatchlistID'])
        else:
            if st.button("View Contents", key=f"view_watchlist_{watchlist['WatchlistID']}"):
                st.session_state['selected_watchlist'] = watchlist['WatchlistID']
                st.rerun()

# Function to show watchlist details
def show_watchlist_details(watchlist_id):
    details = get_watchlist_details(watchlist_id)
    
    if not details:
        st.error("Watchlist not found.")
        st.session_state.pop('selected_watchlist', None)
        return
    
    watchlist = details['watchlist']
    movies = details['movies']
    
    if not movies:
        st.markdown("""
        <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin: 10px 0; text-align: center;">
            <p>This watchlist is empty. Add some movies from the Browse section!</p>
        </div>
        """, unsafe_allow_html=True)
        return
    
    # Display movies in the watchlist
    st.markdown(f"""
    <div style="background-color: #2c2e36; padding: 15px; border-radius: 10px; margin: 10px 0;">
        <h4 style="color: #FF5733; margin-top: 0;">Movies in {watchlist['Name']}</h4>
    </div>
    """, unsafe_allow_html=True)
    
    # Display in grid of 3 columns
    num_cols = 3
    for i in range(0, len(movies), num_cols):
        cols = st.columns(num_cols)
        for j in range(num_cols):
            if i + j < len(movies):
                movie = movies[i + j]
                with cols[j]:
                    st.markdown("""
                    <div style="background-color: #1a1c24; padding: 15px; border-radius: 10px; margin-bottom: 15px; border: 1px solid #2c2e36;">
                    """, unsafe_allow_html=True)
                    
                    # Movie poster
                    poster_url = movie['PosterURL']
                    if poster_url:
                        if poster_url.startswith('http'):
                            try:
                                response = requests.get(poster_url)
                                img = Image.open(BytesIO(response.content))
                                st.image(img, width=150)
                            except:
                                st.image("https://via.placeholder.com/150x225?text=No+Image", width=150)
                        else:
                            # For relative paths
                            st.image("https://via.placeholder.com/150x225?text=Poster+Available", width=150)
                    else:
                        st.image("https://via.placeholder.com/150x225?text=No+Image", width=150)
                    
                    # Movie title and year - FIX: Handle both string and datetime objects
                    release_year = "Unknown"
                    if movie['ReleaseDate']:
                        if isinstance(movie['ReleaseDate'], str):
                            try:
                                release_year = datetime.datetime.strptime(movie['ReleaseDate'], '%Y-%m-%d').year
                            except ValueError:
                                # If parsing fails, try to extract year from string
                                release_year = movie['ReleaseDate'].split('-')[0] if '-' in movie['ReleaseDate'] else "Unknown"
                        else:
                            # It's already a date object
                            release_year = movie['ReleaseDate'].year
                            
                    st.markdown(f"<h4 style='color: #FF5733; margin: 10px 0;'>{movie['Title']} ({release_year})</h4>", unsafe_allow_html=True)
                    
                    # Format added date - similar fix for date handling
                    added_date_display = movie['AddedDate']
                    if isinstance(movie['AddedDate'], datetime.datetime) or isinstance(movie['AddedDate'], datetime.date):
                        added_date_display = movie['AddedDate'].strftime('%Y-%m-%d')
                    
                    st.markdown(f"<p>Added: {added_date_display}</p>", unsafe_allow_html=True)
                    
                    # Action buttons
                    col1, col2 = st.columns(2)
                    with col1:
                        if st.button("View", key=f"view_from_watchlist_{movie['MovieID']}_{i}_{j}"):
                            st.session_state['selected_movie'] = movie['MovieID']
                            st.session_state.pop('selected_watchlist', None)
                            st.rerun()
                    
                    with col2:
                        if st.button("Remove", key=f"remove_watchlist_{movie['MovieID']}_{i}_{j}"):
                            success, message = remove_from_watchlist(watchlist_id, movie['MovieID'])
                            if success:
                                st.success(message)
                                st.rerun()
                            else:
                                st.error(message)
                    
                    st.markdown("</div>", unsafe_allow_html=True)

# Movie Analytics Page
def movie_analytics_page():
    st.markdown("<h2 style='color: #FF5733;'>Movie Analytics</h2>", unsafe_allow_html=True)
    
    # Introduction section
    st.markdown("""
    <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
        <h3 style="color: #FF5733; margin-top: 0;">Movie Database Insights</h3>
        <p>Explore trends and patterns in our movie collection through interactive visualizations.</p>
    </div>
    """, unsafe_allow_html=True)
    
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)  # Use dictionary cursor for MySQL
    
    # Apply custom Seaborn style for better visuals
    sns.set_style("darkgrid", {"axes.facecolor": "#1a1c24"})
    plt.rcParams.update({
        'text.color': 'white',
        'axes.labelcolor': 'white',
        'xtick.color': 'white',
        'ytick.color': 'white',
        'figure.facecolor': '#0e1117',
        'axes.facecolor': '#1a1c24',
        'axes.edgecolor': '#2c2e36',
        'axes.grid': True,
        'grid.color': '#2c2e36',
        'figure.titlesize': 16,
        'axes.titlesize': 14,
        'axes.titlecolor': '#FF5733'
    })
    
    try:
        # Get genre distribution
        cursor.execute("""
        SELECT g.GenreName, COUNT(mg.MovieID) as MovieCount
        FROM Genres g
        JOIN Movie_Genres mg ON g.GenreID = mg.GenreID
        GROUP BY g.GenreName
        ORDER BY MovieCount DESC
        """)
        genre_data = cursor.fetchall()
        
        if genre_data:
            st.markdown("""
            <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
                <h3 style="color: #FF5733; margin-top: 0;">Movies by Genre</h3>
            </div>
            """, unsafe_allow_html=True)
            
            genre_df = pd.DataFrame([(row['GenreName'], row['MovieCount']) for row in genre_data], 
                                   columns=['Genre', 'Count'])
            
            fig, ax = plt.subplots(figsize=(10, 6))
            bars = sns.barplot(x='Genre', y='Count', data=genre_df, ax=ax, palette="flare")
            
            # Add value labels on top of bars
            for i, p in enumerate(bars.patches):
                bars.annotate(f'{p.get_height()}', 
                             (p.get_x() + p.get_width() / 2., p.get_height()), 
                             ha = 'center', va = 'bottom',
                             color='white', fontsize=10, xytext=(0, 5),
                             textcoords='offset points')
            
            plt.xticks(rotation=45, ha='right')
            plt.title('Number of Movies by Genre', color='#FF5733')
            plt.xlabel('Genre')
            plt.ylabel('Number of Movies')
            plt.tight_layout()
            
            st.pyplot(fig)
        
        # Get rating distribution
        cursor.execute("""
        SELECT 
            CASE 
                WHEN Score BETWEEN 1 AND 2 THEN '1-2'
                WHEN Score BETWEEN 2.1 AND 4 THEN '2.1-4'
                WHEN Score BETWEEN 4.1 AND 6 THEN '4.1-6'
                WHEN Score BETWEEN 6.1 AND 8 THEN '6.1-8'
                WHEN Score BETWEEN 8.1 AND 10 THEN '8.1-10'
            END as ScoreRange,
            COUNT(*) as Count
        FROM Ratings
        GROUP BY ScoreRange
        ORDER BY ScoreRange
        """)
        rating_data = cursor.fetchall()
        
        if rating_data:
            st.markdown("""
            <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
                <h3 style="color: #FF5733; margin-top: 0;">Rating Distribution</h3>
            </div>
            """, unsafe_allow_html=True)
            
            rating_df = pd.DataFrame([(row['ScoreRange'], row['Count']) for row in rating_data], 
                                    columns=['Rating Range', 'Count'])
            
            fig, ax = plt.subplots(figsize=(10, 6))
            bars = sns.barplot(x='Rating Range', y='Count', data=rating_df, ax=ax, palette="rocket")
            
            # Add value labels on top of bars
            for i, p in enumerate(bars.patches):
                bars.annotate(f'{p.get_height()}', 
                             (p.get_x() + p.get_width() / 2., p.get_height()), 
                             ha = 'center', va = 'bottom',
                             color='white', fontsize=10, xytext=(0, 5),
                             textcoords='offset points')
            
            plt.title('Distribution of Movie Ratings', color='#FF5733')
            plt.xlabel('Rating Range')
            plt.ylabel('Number of Ratings')
            plt.tight_layout()
            
            st.pyplot(fig)
        
        # Get movies by release year - Modified for MySQL
        cursor.execute("""
        SELECT YEAR(ReleaseDate) as Year, COUNT(*) as MovieCount
        FROM Movies
        GROUP BY Year
        ORDER BY Year
        """)  # Changed strftime to YEAR for MySQL
        year_data = cursor.fetchall()
        
        if year_data:
            st.markdown("""
            <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
                <h3 style="color: #FF5733; margin-top: 0;">Movies by Release Year</h3>
            </div>
            """, unsafe_allow_html=True)
            
            year_df = pd.DataFrame([(str(row['Year']), row['MovieCount']) for row in year_data], 
                                  columns=['Year', 'Count'])
            
            fig, ax = plt.subplots(figsize=(12, 6))
            line = sns.lineplot(x='Year', y='Count', data=year_df, marker='o', linewidth=2.5, color='#FF5733', ax=ax)
            
            # Add value labels on data points
            for x, y in zip(year_df['Year'], year_df['Count']):
                ax.text(x, y + 0.2, str(y), ha='center', va='bottom', color='white', fontsize=9)
            
            plt.title('Movie Releases by Year', color='#FF5733')
            plt.xlabel('Year')
            plt.ylabel('Number of Movies')
            plt.xticks(rotation=45, ha='right')
            plt.grid(True, linestyle='--', alpha=0.7)
            plt.tight_layout()
            
            st.pyplot(fig)
        
        # Top rated movies
        cursor.execute("""
        SELECT m.Title, AVG(r.Score) as AvgRating, COUNT(r.RatingID) as RatingCount
        FROM Movies m
        JOIN Ratings r ON m.MovieID = r.MovieID
        GROUP BY m.MovieID
        HAVING RatingCount >= 1
        ORDER BY AvgRating DESC
        LIMIT 10
        """)
        top_movies = cursor.fetchall()
        
        if top_movies:
            st.markdown("""
            <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
                <h3 style="color: #FF5733; margin-top: 0;">Top Rated Movies</h3>
            </div>
            """, unsafe_allow_html=True)
            
            movies_df = pd.DataFrame([(row['Title'], round(row['AvgRating'], 1), row['RatingCount']) for row in top_movies], 
                                    columns=['Movie', 'Average Rating', 'Number of Ratings'])
            
            # Create a styled table
            fig, ax = plt.subplots(figsize=(10, 6))
            ax.axis('tight')
            ax.axis('off')
            
            # Create table with custom colors
            table = ax.table(cellText=movies_df.values,
                      colLabels=movies_df.columns,
                      cellLoc='center',
                      loc='center',
                      colWidths=[0.5, 0.25, 0.25])
            
            # Style the table
            table.auto_set_font_size(False)
            table.set_fontsize(10)
            table.scale(1.2, 1.5)
            
            # Color the header row
            for j, cell in enumerate(table._cells[(0, j)] for j in range(movies_df.shape[1])):
                cell.set_text_props(weight='bold', color='white')
                cell.set_facecolor('#FF5733')
            
            # Color alternating rows
            for i in range(1, len(movies_df) + 1):
                for j in range(movies_df.shape[1]):
                    cell = table._cells[(i, j)]
                    if i % 2:
                        cell.set_facecolor('#1a1c24')
                    else:
                        cell.set_facecolor('#2c2e36')
                    cell.set_text_props(color='white')
            
            plt.title('Top Rated Movies', color='#FF5733', pad=20, fontsize=16)
            plt.tight_layout()
            
            st.pyplot(fig)
        
        # Average runtime by genre
        cursor.execute("""
        SELECT g.GenreName, AVG(m.Runtime) as AvgRuntime
        FROM Genres g
        JOIN Movie_Genres mg ON g.GenreID = mg.GenreID
        JOIN Movies m ON mg.MovieID = m.MovieID
        GROUP BY g.GenreName
        ORDER BY AvgRuntime DESC
        """)
        runtime_data = cursor.fetchall()
        
        if runtime_data:
            st.markdown("""
            <div style="background-color: #1a1c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #2c2e36;">
                <h3 style="color: #FF5733; margin-top: 0;">Average Runtime by Genre</h3>
            </div>
            """, unsafe_allow_html=True)
            
            runtime_df = pd.DataFrame([(row['GenreName'], int(row['AvgRuntime'])) for row in runtime_data], 
                                     columns=['Genre', 'Average Runtime (minutes)'])
            
            fig, ax = plt.subplots(figsize=(10, 6))
            bars = sns.barplot(x='Genre', y='Average Runtime (minutes)', data=runtime_df, ax=ax, palette="magma")
            
            # Add value labels on top of bars
            for i, p in enumerate(bars.patches):
                bars.annotate(f'{int(p.get_height())}', 
                             (p.get_x() + p.get_width() / 2., p.get_height()), 
                             ha = 'center', va = 'bottom',
                             color='white', fontsize=10, xytext=(0, 5),
                             textcoords='offset points')
            
            plt.xticks(rotation=45, ha='right')
            plt.title('Average Movie Runtime by Genre', color='#FF5733')
            plt.xlabel('Genre')
            plt.ylabel('Runtime (minutes)')
            plt.tight_layout()
            
            st.pyplot(fig)
    
    except Exception as e:
        st.error(f"Error in analytics page: {str(e)}")
        st.exception(e)  # Show detailed error message and stack trace
    
    finally:
        conn.close()

# Run the app
if __name__ == "__main__":
    main()
