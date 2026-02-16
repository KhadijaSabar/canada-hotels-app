CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS hotels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    address VARCHAR(500) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    stars INTEGER CHECK (stars >= 1 AND stars <= 5) NOT NULL,
    amenities TEXT[] DEFAULT '{}',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    hotel_id INTEGER REFERENCES hotels(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    type VARCHAR(100) NOT NULL,
    capacity INTEGER NOT NULL DEFAULT 2,
    price_per_night DECIMAL(10, 2) NOT NULL,
    available_rooms INTEGER NOT NULL DEFAULT 1,
    image_url TEXT,
    amenities TEXT[] DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    room_id INTEGER REFERENCES rooms(id) ON DELETE CASCADE,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INTEGER NOT NULL DEFAULT 1,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    hotel_id INTEGER REFERENCES hotels(id) ON DELETE CASCADE,
    booking_id INTEGER REFERENCES bookings(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_hotels_city ON hotels(city);
CREATE INDEX IF NOT EXISTS idx_hotels_country ON hotels(country);
CREATE INDEX IF NOT EXISTS idx_hotels_stars ON hotels(stars);
CREATE INDEX IF NOT EXISTS idx_rooms_hotel_id ON rooms(hotel_id);
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_room_id ON bookings(room_id);
CREATE INDEX IF NOT EXISTS idx_bookings_dates ON bookings(check_in_date, check_out_date);

INSERT INTO hotels (name, description, address, city, country, stars, amenities, latitude, longitude, image_url) VALUES
(
    'CanadaHotels Montreal Signature',
    'A landmark property in the heart of Old Montreal, the Signature offers an exceptional blend of French-Canadian heritage and contemporary luxury. Overlooking the St. Lawrence River, guests enjoy curated art galleries, a world-class spa, and award-winning cuisine that celebrates Quebec's finest seasonal ingredients.',
    '360 Rue Saint-Jacques, Old Montreal',
    'Montreal',
    'Canada',
    5,
    ARRAY['Spa & Wellness', 'Fine Dining', 'Rooftop Bar', 'Concierge', 'Valet Parking', 'Business Center', 'Indoor Pool', 'Fitness Center'],
    45.5017,
    -73.5673,
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'
),
(
    'CanadaHotels Vancouver Harbour',
    'Perched above Coal Harbour with panoramic views of the Coast Mountains and Burrard Inlet, this contemporary retreat blends West Coast minimalism with refined service. Steps from Stanley Park and the seawall, it is the perfect base for exploring one of the world's most naturally beautiful cities.',
    '1128 W Hastings St, Coal Harbour',
    'Vancouver',
    'Canada',
    5,
    ARRAY['Ocean View Terrace', 'Nordic Spa', 'West Coast Cuisine', 'Bicycle Rentals', 'Marina Access', 'Yoga Studio', 'Indoor Pool', 'Pet Friendly'],
    49.2880,
    -123.1207,
    'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800'
),
(
    'CanadaHotels Toronto Financial District',
    'Toronto's most prestigious business address, situated at the intersection of Bay and King in the heart of the Financial District. With direct access to the PATH underground network, impeccable meeting facilities, and a celebrated steakhouse, this is where deals are made and milestones celebrated.',
    '100 King St W, Financial District',
    'Toronto',
    'Canada',
    4,
    ARRAY['Business Center', 'Meeting Rooms', 'Steakhouse', 'Executive Lounge', 'Fitness Center', 'Concierge', 'Valet Parking', 'Bar & Lounge'],
    43.6484,
    -79.3795,
    'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800'
),
(
    'CanadaHotels Quebec City Chateau',
    'Inspired by the grand chateaux of the Loire Valley, this castle-style property within the walls of Old Quebec commands breathtaking views of the St. Lawrence. A UNESCO World Heritage setting, a legendary dining room, and unmatched access to the city's cobblestone streets make this an unforgettable destination.',
    '1 Rue des Carrieres, Old Quebec',
    'Quebec City',
    'Canada',
    5,
    ARRAY['Historic Castle Setting', 'Signature Restaurant', 'Spa', 'Panoramic Terrace', 'Afternoon Tea', 'Guided City Tours', 'Fireplace Suites', 'Wine Cellar'],
    46.8082,
    -71.2051,
    'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800'
),
(
    'CanadaHotels Calgary Alpine',
    'Gateway to the Canadian Rockies, this contemporary lodge-inspired property celebrates the grandeur of Alberta's landscapes. With direct packages to Banff and Lake Louise, a celebrated après-ski culture, and a rooftop firepit overlooking the Rockies skyline, it is the definitive mountain hospitality experience.',
    '555 9 Ave SW, Downtown Calgary',
    'Calgary',
    'Canada',
    4,
    ARRAY['Mountain View Suites', 'Rooftop Firepit', 'Rocky Mountain Cuisine', 'Ski Concierge', 'Gear Storage', 'Spa', 'Indoor Hot Tub', 'Guided Excursions'],
    51.0451,
    -114.0719,
    'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800'
);

INSERT INTO rooms (hotel_id, name, description, type, capacity, price_per_night, available_rooms, image_url, amenities) VALUES
(1, 'River View Deluxe', 'A refined sanctuary with floor-to-ceiling windows overlooking the St. Lawrence River. Furnished with bespoke Quebec artisan pieces and Frette linens.', 'Deluxe', 2, 320, 8, 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800', ARRAY['King Bed', 'River View', 'Rain Shower', 'Mini Bar', 'Nespresso', 'Bathrobes']),
(1, 'Old Montreal Suite', 'A generous suite with a separate living room, private terrace overlooking Old Montreal rooftops, and an oversized marble bathroom with soaking tub.', 'Suite', 3, 680, 4, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800', ARRAY['King Bed', 'Private Terrace', 'Living Room', 'Marble Bathroom', 'Soaking Tub', 'Butler Service']),
(1, 'Heritage Standard', 'A beautifully appointed room blending exposed stone walls with contemporary comforts, situated in the historic wing of the hotel.', 'Standard', 2, 220, 12, 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?w=800', ARRAY['Queen Bed', 'Stone Wall Feature', 'Work Desk', 'Flat Screen TV', 'Nespresso']),
(2, 'Harbour View King', 'Wake to postcard views of Coal Harbour and the North Shore mountains. Beautifully appointed in natural materials celebrating British Columbia''s landscapes.', 'Deluxe', 2, 420, 6, 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800', ARRAY['King Bed', 'Mountain & Water View', 'Rainfall Shower', 'Heated Floors', 'Mini Bar', 'Binoculars']),
(2, 'West Coast Penthouse', 'The pinnacle of Vancouver luxury. An entire floor with 360-degree views of the city, mountains and harbour. Private rooftop terrace with hot tub.', 'Penthouse', 4, 1200, 1, 'https://images.unsplash.com/photo-1613553507747-5f8d62ad5904?w=800', ARRAY['2 King Bedrooms', 'Private Rooftop', 'Hot Tub', 'Chef''s Kitchen', 'Private Elevator', 'Butler Service']),
(2, 'Forest Standard', 'A peaceful retreat with views of the surrounding cedar and fir trees. Minimalist West Coast design with premium organic amenities.', 'Standard', 2, 280, 10, 'https://images.unsplash.com/photo-1505693314120-0d443867891c?w=800', ARRAY['Queen Bed', 'Forest View', 'Organic Toiletries', 'Work Desk', 'Smart TV']),
(3, 'Executive City View', 'A polished executive room on the upper floors with commanding views across the Toronto skyline. Tailored for the discerning business traveller.', 'Executive', 2, 310, 15, 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800', ARRAY['King Bed', 'City Skyline View', 'Work Desk', 'Executive Lounge Access', 'Nespresso', 'Ergonomic Chair']),
(3, 'Business Suite', 'A full suite with separate meeting area, dual monitors, and priority access to all business facilities. Ideal for extended corporate stays.', 'Suite', 2, 520, 5, 'https://images.unsplash.com/photo-1562790351-d273a961e0e9?w=800', ARRAY['King Bed', 'Meeting Table for 4', 'Dual Monitor Setup', 'Printer', 'Nespresso', 'Express Pressing']),
(4, 'Chateau Classic', 'Steeped in history, this classically appointed room features original stone detailing, antique furnishings, and views across the fortifications of Old Quebec.', 'Classic', 2, 390, 10, 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800', ARRAY['Queen Bed', 'Stone Detailing', 'Period Furniture', 'Claw-Foot Tub', 'Fireplace', 'Castle Views']),
(4, 'Turret Suite', 'Occupying one of the chateau''s historic turrets, this unique circular suite offers 180-degree panoramas of the St. Lawrence River and the Lower Town below.', 'Suite', 3, 950, 2, 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800', ARRAY['King Bed', '180° Panoramic Views', 'Turret Sitting Area', 'Clawfoot Tub', 'Fireplace', 'Champagne on Arrival']),
(5, 'Rocky Mountain Standard', 'A cozy, lodge-inspired room with locally sourced pine furnishings and views across Calgary''s skyline toward the distant Rockies.', 'Standard', 2, 240, 14, 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=800', ARRAY['Queen Bed', 'Mountain View', 'Stone Fireplace', 'Work Desk', 'Nespresso']),
(5, 'Alpine Loft Suite', 'A dramatic double-height suite with exposed timber beams, a loft bedroom, and a private terrace with a propane firepit and unobstructed Rockies views.', 'Suite', 4, 780, 3, 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800', ARRAY['King Loft Bedroom', 'Private Firepit Terrace', 'Soaking Tub', 'Double-Height Ceiling', 'Ski Storage', 'Butler Service']);
