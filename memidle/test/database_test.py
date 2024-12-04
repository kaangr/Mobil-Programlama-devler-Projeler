import sqlite3
import random
import string

# Rastgele şifre oluşturma fonksiyonu
def random_password(length=8):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def test_insert_random_data():
    try:
        # Veritabanına bağlan
        conn = sqlite3.connect(r'D:\Programming\Mobil-Programlama-devler-Projeler\memidle\lib\services\user.db')
        cursor = conn.cursor()

        # 10 kullanıcıyı veritabanına ekle (yine de aynı kullanıcı adı olmamalı)
        for i in range(1, 11):
            username = f"user{i}"
            password = random_password()  # Rastgele şifre oluştur
            try:
                cursor.execute('''
                INSERT INTO users (username, password) 
                VALUES (?, ?)
                ''', (username, password))
            except sqlite3.IntegrityError:
                pass  # Eğer kullanıcı adı zaten varsa, hatayı yoksay

        # Kullanıcıları sorgula ve kullanıcı id'lerini al
        cursor.execute("SELECT id FROM users")
        user_ids = [row[0] for row in cursor.fetchall()]

        # 10 meme verisini memes tablosuna ekle
        for i in range(1, 11):
            user_id = random.choice(user_ids)  # Rastgele bir kullanıcı seç
            image_path = r"D:\Programming\Mobil-Programlama-devler-Projeler\memidle\data\assets\images\green.jpg"
            cursor.execute('''
            INSERT INTO memes (user_id, image_path)
            VALUES (?, ?)
            ''', (user_id, image_path))

        # Veritabanındaki verileri yazdır
        print("Users:")
        cursor.execute("SELECT userid, username, password FROM users")
        users = cursor.fetchall()
        for user in users:
            print(user)

        print("\nMemes:")
        cursor.execute("SELECT id, user_id, image_path, created_at FROM memes")
        memes = cursor.fetchall()
        for meme in memes:
            print(meme)

        # Değişiklikleri kaydet
        conn.commit()

    except sqlite3.Error as e:
        print("SQLite hatası:", e)

    finally:
        # Bağlantıyı kapat
        if conn:
            conn.close()

# Fonksiyonu çağırarak test işlemini başlat
test_insert_random_data()
