CREATE TABLE users (
    user_id       BIGSERIAL    PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    password_hash TEXT         NOT NULL,
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    profile_id BIGSERIAL   PRIMARY KEY,
    user_id    BIGINT      UNIQUE NOT NULL,
    address    TEXT,
    birth_date DATE,
    gender     VARCHAR(10),
    avatar_url VARCHAR(500),
    CONSTRAINT fk_profile_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE events (
    event_id    BIGSERIAL    PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    description TEXT,
    location    VARCHAR(255) NOT NULL,
    event_date  TIMESTAMP    NOT NULL,
    organizer   VARCHAR(150) NOT NULL,
    poster_url  VARCHAR(500),
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ticket_categories (
    category_id   BIGSERIAL     PRIMARY KEY,
    event_id      BIGINT        NOT NULL,
    category_name VARCHAR(100)  NOT NULL,
    price         NUMERIC(12,2) NOT NULL,
    quota         INT           NOT NULL DEFAULT 0,
    sold          INT           NOT NULL DEFAULT 0,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ticket_event
        FOREIGN KEY (event_id) REFERENCES events(event_id)
        ON DELETE CASCADE
);

CREATE TABLE orders (
    order_id       BIGSERIAL     PRIMARY KEY,
    user_id        BIGINT,
    guest_name     VARCHAR(100),
    guest_email    VARCHAR(150),
    guest_phone    VARCHAR(20),
    order_code     VARCHAR(50)   UNIQUE NOT NULL,
    total_amount   NUMERIC(14,2) NOT NULL DEFAULT 0,
    status         VARCHAR(20)   DEFAULT 'pending',
    payment_method VARCHAR(50),
    ordered_at     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    paid_at        TIMESTAMP,
    CONSTRAINT fk_order_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id      BIGSERIAL     PRIMARY KEY,
    order_id           BIGINT        NOT NULL,
    ticket_category_id BIGINT        NOT NULL,
    quantity           INT           NOT NULL DEFAULT 1,
    subtotal           NUMERIC(14,2) NOT NULL,
    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_item_ticket
        FOREIGN KEY (ticket_category_id)
        REFERENCES ticket_categories(category_id)
);

-- Users
INSERT INTO users (name, email, phone, password_hash) VALUES
('Swen Wijaya', 'swenwi@email.com',  '081234567890', 'hashed_pw_swenwi'),
('Awa Rahayu',  'awahayu@email.com', '082345678901', 'hashed_pw_awahayu'),
('Andi Hansa',  'hansadi@email.com', '083456789012', 'hashed_pw_hansadi');

-- User Profiles
INSERT INTO user_profiles (user_id, address, birth_date, gender, avatar_url) VALUES
(1, 'Jl. Kenanga No. 12, Jakarta',   '2002-10-26', 'male',   'https://cdn.loket.com/avatar/swen.jpg'),
(2, 'Jl. Melati No. 3, Depok',       '2005-09-28', 'female', 'https://cdn.loket.com/avatar/awa.jpg'),
(3, 'Jl. Mawar No. 7, Tangerang',    '2000-11-22', 'male',   'https://cdn.loket.com/avatar/andi.jpg');

-- Event
INSERT INTO events (title, description, location, event_date, organizer) VALUES
(
    '10 Years of Reality Club Live in Jakarta',
    'Perayaan 10 tahun Reality Club menggelar konser spesial di Jakarta. Malam penuh nostalgia membawakan lagu-lagu ikonik dari seluruh diskografi mereka.',
    'Istora Senayan, Jakarta',
    '2025-08-23 19:00:00',
    'Loket Live'
);

-- Ticket Categories
INSERT INTO ticket_categories (event_id, category_name, price, quota, sold) VALUES
(1, 'Normal Festival',   449000, 1000, 450),
(1, 'VIP Festival',       1549000,  300,  120),
(1, 'Tribune Ticket',        449000,  150,   60);

-- Orders: Swen & Awa login, 1 guest
INSERT INTO orders (user_id, guest_name, guest_email, guest_phone, order_code, total_amount, status, payment_method, paid_at) VALUES
(1,    NULL,          NULL,                  NULL,           'ORD-RC-001',  449000, 'paid',    'gopay',         '2025-06-01 10:15:00'),
(2,    NULL,          NULL,                  NULL,           'ORD-RC-002',  449000, 'paid',    'bank_transfer', '2025-06-01 11:30:00'),
(NULL, 'Joyce', 'joyce@email.com',     '08812925671', 'ORD-RC-003',  1549000, 'pending',  NULL,            NULL);

-- Order Items
INSERT INTO order_items (order_id, ticket_category_id, quantity, subtotal) VALUES
(1, 1, 1,  449000),   -- Swen: 1x Normal Festival
(2, 3, 1,  449000),   -- Awa: 1x Tribune Ticket
(3, 2, 1, 1549000);   -- Joyce (guest): 1x VIP Festival