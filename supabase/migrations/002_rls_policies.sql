-- ==============================================================================
-- ROUTINE FLOW - Row-Level Security Policies (002_rls_policies.sql)
-- Multi-Tenant University Isolation + Student Privacy Separation
-- ==============================================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE universities ENABLE ROW LEVEL SECURITY;
ALTER TABLE academic_terms ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_offerings ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE habits ENABLE ROW LEVEL SECURITY;
ALTER TABLE habit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE exams ENABLE ROW LEVEL SECURITY;
ALTER TABLE deadlines ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_usage_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role = 'super_admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_university_admin(target_univ_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid() AND role IN ('super_admin', 'university_admin') AND (university_id = target_univ_id OR role = 'super_admin')
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE POLICY "Users can view own profile or campus peers" ON profiles
    FOR SELECT USING (auth.uid() = id OR university_id IN (SELECT university_id FROM profiles WHERE id = auth.uid()) OR is_super_admin());

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Public read access for universities" ON universities
    FOR SELECT USING (true);

CREATE POLICY "Academic terms read by campus members" ON academic_terms
    FOR SELECT USING (true);

CREATE POLICY "Departments read by all" ON departments
    FOR SELECT USING (true);

CREATE POLICY "Courses read by all" ON courses
    FOR SELECT USING (true);

CREATE POLICY "Course offerings read by all" ON course_offerings
    FOR SELECT USING (true);

CREATE POLICY "Students view own enrollments" ON student_enrollments
    FOR SELECT USING (auth.uid() = user_id OR is_super_admin());

CREATE POLICY "Students enroll themselves" ON student_enrollments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view personal activities and university classes" ON activities
    FOR SELECT USING (
        user_id = auth.uid() 
        OR (university_id IS NOT NULL AND university_id IN (SELECT university_id FROM profiles WHERE id = auth.uid()))
        OR is_super_admin()
    );

CREATE POLICY "Users can manage personal activities" ON activities
    FOR ALL USING (
        user_id = auth.uid() 
        OR (university_id IS NOT NULL AND is_university_admin(university_id))
    );

CREATE POLICY "User tasks isolation" ON tasks
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "User habits isolation" ON habits
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "User habit logs isolation" ON habit_logs
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "User goals isolation" ON goals
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Read exams for university members" ON exams
    FOR SELECT USING (
        university_id IN (SELECT university_id FROM profiles WHERE id = auth.uid()) OR is_super_admin()
    );

CREATE POLICY "Read deadlines for university members" ON deadlines
    FOR SELECT USING (
        university_id IN (SELECT university_id FROM profiles WHERE id = auth.uid()) OR is_super_admin()
    );

CREATE POLICY "Public read subscription plans" ON subscription_plans
    FOR SELECT USING (is_active = true OR is_super_admin());

CREATE POLICY "User view own subscription" ON user_subscriptions
    FOR SELECT USING (auth.uid() = user_id OR is_super_admin());

CREATE POLICY "User view own payment transactions" ON payment_transactions
    FOR SELECT USING (auth.uid() = user_id OR is_super_admin());

CREATE POLICY "User view own AI usage" ON ai_usage_logs
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "User view own notifications" ON notification_logs
    FOR ALL USING (auth.uid() = user_id);
