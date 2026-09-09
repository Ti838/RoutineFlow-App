-- ==============================================================================
-- ROUTINE FLOW - Seed Data (003_seed_data.sql)
-- Test Universities, Courses, Schedules, Plans & Admin Users
-- ==============================================================================

INSERT INTO subscription_plans (id, name, description, price_cents, currency, interval, features)
VALUES 
    ('free', 'Free Student Tier', 'Essential personal and university schedule sync with conflict alerts.', 0, 'USD', 'month', '["Unified daily schedule", "Manual activity logging", "Basic conflict detection", "Up to 3 habits"]'::jsonb),
    ('pro_monthly', 'Pro Student (Monthly)', 'Full AI daily planner, unlimited habits, automatic smart rescheduling.', 499, 'USD', 'month', '["Unlimited habits & goals", "Full AI Daily Planner", "Exam Sprint auto-scheduler", "Cloud multi-device sync", "Priority support"]'::jsonb),
    ('pro_yearly', 'Pro Student (Yearly)', 'Save 30% on annual Pro Student subscription with all AI features.', 3999, 'USD', 'year', '["All Monthly Pro features", "2 months free", "Beta access to new AI features", "Offline-first smart backup"]'::jsonb),
    ('campus_tier', 'Campus Enterprise', 'Direct university LMS integration, official syllabus sync.', 0, 'USD', 'year', '["Official LMS sync", "Department announcements", "Classroom change alerts", "Faculty office hours booking"]'::jsonb)
ON CONFLICT (id) DO NOTHING;

INSERT INTO universities (id, name, short_code, domain, logo_url, timezone, address)
VALUES 
    ('a0000000-0000-0000-0000-000000000001', 'Apex Institute of Technology', 'AIT', 'ait.edu', 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=200', 'UTC', '100 Innovation Way, Tech City'),
    ('a0000000-0000-0000-0000-000000000002', 'Metropolitan University', 'MU', 'metro.edu', 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=200', 'UTC', '500 University Ave, Metro City')
ON CONFLICT (short_code) DO NOTHING;

INSERT INTO academic_terms (id, university_id, name, start_date, end_date, is_active)
VALUES 
    ('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'Fall 2026', '2026-09-01', '2026-12-20', true),
    ('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000002', 'Fall 2026', '2026-09-01', '2026-12-20', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO departments (id, university_id, name, code, head_name)
VALUES 
    ('c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'Computer Science and Engineering', 'CSE', 'Dr. Alan Turing'),
    ('c0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', 'Business Administration', 'BBA', 'Dr. Peter Drucker')
ON CONFLICT (id) DO NOTHING;

INSERT INTO courses (id, department_id, university_id, code, title, credit_hours, description)
VALUES 
    ('d0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'CSE 301', 'Algorithms & Data Structures', 3.0, 'Advanced algorithm design, graphs, dynamic programming and NP-completeness.'),
    ('d0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'CSE 320', 'Database Systems', 3.0, 'Relational model, SQL, indexing, transactions and distributed databases.'),
    ('d0000000-0000-0000-0000-000000000003', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'MAT 205', 'Linear Algebra & Calculus', 3.0, 'Vector spaces, eigenvalues, matrix decompositions and multivariate calculus.')
ON CONFLICT (id) DO NOTHING;

INSERT INTO course_offerings (id, course_id, term_id, section, instructor_name, room_number)
VALUES 
    ('e0000000-0000-0000-0000-000000000001', 'd0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001', 'Sec 01', 'Prof. Ada Lovelace', 'Lab 402'),
    ('e0000000-0000-0000-0000-000000000002', 'd0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000001', 'Sec 02', 'Prof. Edgar Codd', 'Auditorium A'),
    ('e0000000-0000-0000-0000-000000000003', 'd0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000001', 'Sec 01', 'Prof. Carl Gauss', 'Room 305')
ON CONFLICT (id) DO NOTHING;
