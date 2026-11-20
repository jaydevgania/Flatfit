-- 017_rls_policies.sql
-- Row Level Security policies for ALL tables

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Check if user is an admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM admin_users
        WHERE user_id = auth.uid() AND is_active = true
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is a flat member
CREATE OR REPLACE FUNCTION is_flat_member(p_flat_id uuid)
RETURNS boolean AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM flat_members
        WHERE flat_id = p_flat_id AND user_id = auth.uid() AND left_at IS NULL
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is a conversation member
CREATE OR REPLACE FUNCTION is_conversation_member(p_conversation_id uuid)
RETURNS boolean AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM conversation_members
        WHERE conversation_id = p_conversation_id AND user_id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- PROFILES
-- ============================================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY profiles_select ON profiles
    FOR SELECT USING (true); -- anyone can see profiles for discovery

CREATE POLICY profiles_insert ON profiles
    FOR INSERT WITH CHECK (id = auth.uid());

CREATE POLICY profiles_update ON profiles
    FOR UPDATE USING (id = auth.uid());

CREATE POLICY profiles_delete ON profiles
    FOR DELETE USING (id = auth.uid() OR is_admin());

-- ============================================================================
-- PROFILE PHOTOS
-- ============================================================================
ALTER TABLE profile_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY profile_photos_select ON profile_photos
    FOR SELECT USING (true); -- visible during discovery

CREATE POLICY profile_photos_insert ON profile_photos
    FOR INSERT WITH CHECK (profile_id = auth.uid());

CREATE POLICY profile_photos_update ON profile_photos
    FOR UPDATE USING (profile_id = auth.uid());

CREATE POLICY profile_photos_delete ON profile_photos
    FOR DELETE USING (profile_id = auth.uid());

-- ============================================================================
-- VOICE INTROS
-- ============================================================================
ALTER TABLE voice_intros ENABLE ROW LEVEL SECURITY;

CREATE POLICY voice_intros_select ON voice_intros
    FOR SELECT USING (true);

CREATE POLICY voice_intros_insert ON voice_intros
    FOR INSERT WITH CHECK (profile_id = auth.uid());

CREATE POLICY voice_intros_update ON voice_intros
    FOR UPDATE USING (profile_id = auth.uid());

CREATE POLICY voice_intros_delete ON voice_intros
    FOR DELETE USING (profile_id = auth.uid());

-- ============================================================================
-- QUESTIONS
-- ============================================================================
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY questions_select ON questions
    FOR SELECT USING (true); -- everyone can read questions

CREATE POLICY questions_admin_insert ON questions
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY questions_admin_update ON questions
    FOR UPDATE USING (is_admin());

CREATE POLICY questions_admin_delete ON questions
    FOR DELETE USING (is_admin());

-- ============================================================================
-- USER ANSWERS
-- ============================================================================
ALTER TABLE user_answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY user_answers_select_own ON user_answers
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY user_answers_insert ON user_answers
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY user_answers_update ON user_answers
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY user_answers_delete ON user_answers
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================================
-- PRECOMPUTED MATCHES
-- ============================================================================
ALTER TABLE precomputed_matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY matches_select ON precomputed_matches
    FOR SELECT USING (user_a = auth.uid() OR user_b = auth.uid());

-- Only system/edge functions can insert/update/delete matches (via service_role)
CREATE POLICY matches_admin_insert ON precomputed_matches
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY matches_admin_update ON precomputed_matches
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- INTERESTS
-- ============================================================================
ALTER TABLE interests ENABLE ROW LEVEL SECURITY;

CREATE POLICY interests_select ON interests
    FOR SELECT USING (from_user = auth.uid() OR to_user = auth.uid());

CREATE POLICY interests_insert ON interests
    FOR INSERT WITH CHECK (from_user = auth.uid());

CREATE POLICY interests_update ON interests
    FOR UPDATE USING (to_user = auth.uid()); -- only recipient can accept/decline

CREATE POLICY interests_delete ON interests
    FOR DELETE USING (from_user = auth.uid()); -- only sender can retract

-- ============================================================================
-- SAVED SEARCHES
-- ============================================================================
ALTER TABLE saved_searches ENABLE ROW LEVEL SECURITY;

CREATE POLICY saved_searches_select ON saved_searches
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY saved_searches_insert ON saved_searches
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY saved_searches_update ON saved_searches
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY saved_searches_delete ON saved_searches
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================================
-- SHORTLISTS
-- ============================================================================
ALTER TABLE shortlists ENABLE ROW LEVEL SECURITY;

CREATE POLICY shortlists_select ON shortlists
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY shortlists_insert ON shortlists
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY shortlists_delete ON shortlists
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================================
-- GROUPS
-- ============================================================================
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;

CREATE POLICY groups_select ON groups
    FOR SELECT USING (
        created_by = auth.uid()
        OR EXISTS (SELECT 1 FROM group_members WHERE group_id = groups.id AND user_id = auth.uid())
    );

CREATE POLICY groups_insert ON groups
    FOR INSERT WITH CHECK (created_by = auth.uid());

CREATE POLICY groups_update ON groups
    FOR UPDATE USING (created_by = auth.uid());

CREATE POLICY groups_delete ON groups
    FOR DELETE USING (created_by = auth.uid());

-- ============================================================================
-- GROUP MEMBERS
-- ============================================================================
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY group_members_select ON group_members
    FOR SELECT USING (
        EXISTS (SELECT 1 FROM group_members gm WHERE gm.group_id = group_members.group_id AND gm.user_id = auth.uid())
    );

CREATE POLICY group_members_insert ON group_members
    FOR INSERT WITH CHECK (
        EXISTS (SELECT 1 FROM groups WHERE id = group_id AND created_by = auth.uid())
        OR user_id = auth.uid() -- user can join themselves
    );

CREATE POLICY group_members_delete ON group_members
    FOR DELETE USING (
        user_id = auth.uid() -- can leave
        OR EXISTS (SELECT 1 FROM groups WHERE id = group_id AND created_by = auth.uid()) -- creator can remove
    );

-- ============================================================================
-- CONVERSATIONS
-- ============================================================================
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;

CREATE POLICY conversations_select ON conversations
    FOR SELECT USING (is_conversation_member(id));

CREATE POLICY conversations_insert ON conversations
    FOR INSERT WITH CHECK (true); -- validated in application logic

-- ============================================================================
-- CONVERSATION MEMBERS
-- ============================================================================
ALTER TABLE conversation_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY conversation_members_select ON conversation_members
    FOR SELECT USING (is_conversation_member(conversation_id));

CREATE POLICY conversation_members_insert ON conversation_members
    FOR INSERT WITH CHECK (user_id = auth.uid() OR is_conversation_member(conversation_id));

-- ============================================================================
-- MESSAGES
-- ============================================================================
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY messages_select ON messages
    FOR SELECT USING (is_conversation_member(conversation_id));

CREATE POLICY messages_insert ON messages
    FOR INSERT WITH CHECK (
        sender_id = auth.uid()
        AND is_conversation_member(conversation_id)
    );

CREATE POLICY messages_update ON messages
    FOR UPDATE USING (sender_id = auth.uid()); -- can only edit/delete own

-- ============================================================================
-- BLOCKED USERS
-- ============================================================================
ALTER TABLE blocked_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY blocked_users_select ON blocked_users
    FOR SELECT USING (blocker_id = auth.uid());

CREATE POLICY blocked_users_insert ON blocked_users
    FOR INSERT WITH CHECK (blocker_id = auth.uid());

CREATE POLICY blocked_users_delete ON blocked_users
    FOR DELETE USING (blocker_id = auth.uid());

-- ============================================================================
-- REPORTS
-- ============================================================================
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY reports_select_own ON reports
    FOR SELECT USING (reporter_id = auth.uid() OR is_admin());

CREATE POLICY reports_insert ON reports
    FOR INSERT WITH CHECK (reporter_id = auth.uid());

CREATE POLICY reports_admin_update ON reports
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- LISTINGS
-- ============================================================================
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;

CREATE POLICY listings_select ON listings
    FOR SELECT USING (
        status = 'active' -- anyone can see active listings
        OR owner_id = auth.uid() -- owner can see all their own
        OR is_admin()
    );

CREATE POLICY listings_insert ON listings
    FOR INSERT WITH CHECK (owner_id = auth.uid());

CREATE POLICY listings_update ON listings
    FOR UPDATE USING (owner_id = auth.uid() OR is_admin());

CREATE POLICY listings_delete ON listings
    FOR DELETE USING (owner_id = auth.uid() OR is_admin());

-- ============================================================================
-- LISTING PHOTOS
-- ============================================================================
ALTER TABLE listing_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY listing_photos_select ON listing_photos
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM listings
            WHERE id = listing_photos.listing_id
            AND (status = 'active' OR owner_id = auth.uid())
        )
    );

CREATE POLICY listing_photos_insert ON listing_photos
    FOR INSERT WITH CHECK (
        EXISTS (SELECT 1 FROM listings WHERE id = listing_id AND owner_id = auth.uid())
    );

CREATE POLICY listing_photos_update ON listing_photos
    FOR UPDATE USING (
        EXISTS (SELECT 1 FROM listings WHERE id = listing_id AND owner_id = auth.uid())
    );

CREATE POLICY listing_photos_delete ON listing_photos
    FOR DELETE USING (
        EXISTS (SELECT 1 FROM listings WHERE id = listing_id AND owner_id = auth.uid())
    );

-- ============================================================================
-- LISTING AMENITIES
-- ============================================================================
ALTER TABLE listing_amenities ENABLE ROW LEVEL SECURITY;

CREATE POLICY listing_amenities_select ON listing_amenities
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM listings
            WHERE id = listing_amenities.listing_id
            AND (status = 'active' OR owner_id = auth.uid())
        )
    );

CREATE POLICY listing_amenities_insert ON listing_amenities
    FOR INSERT WITH CHECK (
        EXISTS (SELECT 1 FROM listings WHERE id = listing_id AND owner_id = auth.uid())
    );

CREATE POLICY listing_amenities_delete ON listing_amenities
    FOR DELETE USING (
        EXISTS (SELECT 1 FROM listings WHERE id = listing_id AND owner_id = auth.uid())
    );

-- ============================================================================
-- VERIFICATIONS
-- ============================================================================
ALTER TABLE verifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY verifications_select ON verifications
    FOR SELECT USING (user_id = auth.uid() OR is_admin());

CREATE POLICY verifications_insert ON verifications
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY verifications_admin_update ON verifications
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- TRUST SCORES
-- ============================================================================
ALTER TABLE trust_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY trust_scores_select ON trust_scores
    FOR SELECT USING (true); -- trust scores are public (part of profiles)

CREATE POLICY trust_scores_admin_insert ON trust_scores
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY trust_scores_admin_update ON trust_scores
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- REVIEWS
-- ============================================================================
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY reviews_select ON reviews
    FOR SELECT USING (
        reviewer_id = auth.uid()
        OR reviewee_id = auth.uid()
        OR is_admin()
    );

CREATE POLICY reviews_select_public ON reviews
    FOR SELECT USING (NOT is_anonymous OR reviewee_id = auth.uid());

CREATE POLICY reviews_insert ON reviews
    FOR INSERT WITH CHECK (reviewer_id = auth.uid());

CREATE POLICY reviews_update ON reviews
    FOR UPDATE USING (reviewer_id = auth.uid());

CREATE POLICY reviews_admin_delete ON reviews
    FOR DELETE USING (is_admin());

-- ============================================================================
-- AGREEMENTS
-- ============================================================================
ALTER TABLE agreements ENABLE ROW LEVEL SECURITY;

CREATE POLICY agreements_select ON agreements
    FOR SELECT USING (
        is_flat_member(flat_id) OR created_by = auth.uid() OR is_admin()
    );

CREATE POLICY agreements_insert ON agreements
    FOR INSERT WITH CHECK (created_by = auth.uid());

CREATE POLICY agreements_update ON agreements
    FOR UPDATE USING (created_by = auth.uid() OR is_admin());

-- ============================================================================
-- AGREEMENT SIGNATURES
-- ============================================================================
ALTER TABLE agreement_signatures ENABLE ROW LEVEL SECURITY;

CREATE POLICY agreement_signatures_select ON agreement_signatures
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM agreements a
            WHERE a.id = agreement_signatures.agreement_id
            AND (is_flat_member(a.flat_id) OR a.created_by = auth.uid())
        )
    );

CREATE POLICY agreement_signatures_insert ON agreement_signatures
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- ============================================================================
-- MOVE-IN CHECKLISTS
-- ============================================================================
ALTER TABLE move_in_checklists ENABLE ROW LEVEL SECURITY;

CREATE POLICY move_in_checklists_select ON move_in_checklists
    FOR SELECT USING (
        user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM agreements a
            WHERE a.id = move_in_checklists.agreement_id
            AND is_flat_member(a.flat_id)
        )
    );

CREATE POLICY move_in_checklists_insert ON move_in_checklists
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY move_in_checklists_update ON move_in_checklists
    FOR UPDATE USING (user_id = auth.uid());

-- ============================================================================
-- FLATS
-- ============================================================================
ALTER TABLE flats ENABLE ROW LEVEL SECURITY;

CREATE POLICY flats_select ON flats
    FOR SELECT USING (is_flat_member(id) OR is_admin());

CREATE POLICY flats_insert ON flats
    FOR INSERT WITH CHECK (true); -- validated in application

CREATE POLICY flats_update ON flats
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM flat_members
            WHERE flat_id = flats.id AND user_id = auth.uid() AND role = 'admin' AND left_at IS NULL
        )
    );

-- ============================================================================
-- FLAT MEMBERS
-- ============================================================================
ALTER TABLE flat_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY flat_members_select ON flat_members
    FOR SELECT USING (is_flat_member(flat_id));

CREATE POLICY flat_members_insert ON flat_members
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM flat_members fm
            WHERE fm.flat_id = flat_members.flat_id AND fm.user_id = auth.uid() AND fm.role = 'admin' AND fm.left_at IS NULL
        )
        OR user_id = auth.uid()
    );

CREATE POLICY flat_members_update ON flat_members
    FOR UPDATE USING (
        user_id = auth.uid() -- can update own membership (leave)
        OR EXISTS (
            SELECT 1 FROM flat_members fm
            WHERE fm.flat_id = flat_members.flat_id AND fm.user_id = auth.uid() AND fm.role = 'admin' AND fm.left_at IS NULL
        )
    );

-- ============================================================================
-- EXPENSES
-- ============================================================================
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

CREATE POLICY expenses_select ON expenses
    FOR SELECT USING (is_flat_member(flat_id));

CREATE POLICY expenses_insert ON expenses
    FOR INSERT WITH CHECK (paid_by = auth.uid() AND is_flat_member(flat_id));

CREATE POLICY expenses_update ON expenses
    FOR UPDATE USING (paid_by = auth.uid());

CREATE POLICY expenses_delete ON expenses
    FOR DELETE USING (paid_by = auth.uid());

-- ============================================================================
-- EXPENSE SPLITS
-- ============================================================================
ALTER TABLE expense_splits ENABLE ROW LEVEL SECURITY;

CREATE POLICY expense_splits_select ON expense_splits
    FOR SELECT USING (
        user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM expenses e WHERE e.id = expense_splits.expense_id AND is_flat_member(e.flat_id)
        )
    );

CREATE POLICY expense_splits_insert ON expense_splits
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM expenses e WHERE e.id = expense_id AND e.paid_by = auth.uid()
        )
    );

CREATE POLICY expense_splits_update ON expense_splits
    FOR UPDATE USING (
        user_id = auth.uid() -- can settle own splits
        OR EXISTS (
            SELECT 1 FROM expenses e WHERE e.id = expense_splits.expense_id AND e.paid_by = auth.uid()
        )
    );

-- ============================================================================
-- CHORES
-- ============================================================================
ALTER TABLE chores ENABLE ROW LEVEL SECURITY;

CREATE POLICY chores_select ON chores
    FOR SELECT USING (is_flat_member(flat_id));

CREATE POLICY chores_insert ON chores
    FOR INSERT WITH CHECK (is_flat_member(flat_id));

CREATE POLICY chores_update ON chores
    FOR UPDATE USING (is_flat_member(flat_id));

CREATE POLICY chores_delete ON chores
    FOR DELETE USING (is_flat_member(flat_id));

-- ============================================================================
-- CHORE ASSIGNMENTS
-- ============================================================================
ALTER TABLE chore_assignments ENABLE ROW LEVEL SECURITY;

CREATE POLICY chore_assignments_select ON chore_assignments
    FOR SELECT USING (
        user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM chores c WHERE c.id = chore_assignments.chore_id AND is_flat_member(c.flat_id)
        )
    );

CREATE POLICY chore_assignments_insert ON chore_assignments
    FOR INSERT WITH CHECK (
        EXISTS (SELECT 1 FROM chores c WHERE c.id = chore_id AND is_flat_member(c.flat_id))
    );

CREATE POLICY chore_assignments_update ON chore_assignments
    FOR UPDATE USING (user_id = auth.uid()); -- can mark own chores complete

-- ============================================================================
-- CALENDAR EVENTS
-- ============================================================================
ALTER TABLE calendar_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY calendar_events_select ON calendar_events
    FOR SELECT USING (is_flat_member(flat_id));

CREATE POLICY calendar_events_insert ON calendar_events
    FOR INSERT WITH CHECK (user_id = auth.uid() AND is_flat_member(flat_id));

CREATE POLICY calendar_events_update ON calendar_events
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY calendar_events_delete ON calendar_events
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================================
-- NOTICES
-- ============================================================================
ALTER TABLE notices ENABLE ROW LEVEL SECURITY;

CREATE POLICY notices_select ON notices
    FOR SELECT USING (is_flat_member(flat_id));

CREATE POLICY notices_insert ON notices
    FOR INSERT WITH CHECK (user_id = auth.uid() AND is_flat_member(flat_id));

CREATE POLICY notices_update ON notices
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY notices_delete ON notices
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================================
-- GROCERY ITEMS
-- ============================================================================
ALTER TABLE grocery_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY grocery_items_select ON grocery_items
    FOR SELECT USING (is_flat_member(flat_id));

CREATE POLICY grocery_items_insert ON grocery_items
    FOR INSERT WITH CHECK (added_by = auth.uid() AND is_flat_member(flat_id));

CREATE POLICY grocery_items_update ON grocery_items
    FOR UPDATE USING (is_flat_member(flat_id)); -- any member can mark as bought

CREATE POLICY grocery_items_delete ON grocery_items
    FOR DELETE USING (added_by = auth.uid());

-- ============================================================================
-- HOUSE INVENTORY
-- ============================================================================
ALTER TABLE house_inventory ENABLE ROW LEVEL SECURITY;

CREATE POLICY house_inventory_select ON house_inventory
    FOR SELECT USING (is_flat_member(flat_id));

CREATE POLICY house_inventory_insert ON house_inventory
    FOR INSERT WITH CHECK (is_flat_member(flat_id));

CREATE POLICY house_inventory_update ON house_inventory
    FOR UPDATE USING (is_flat_member(flat_id));

CREATE POLICY house_inventory_delete ON house_inventory
    FOR DELETE USING (is_flat_member(flat_id));

-- ============================================================================
-- PAYMENTS
-- ============================================================================
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

CREATE POLICY payments_select ON payments
    FOR SELECT USING (user_id = auth.uid() OR is_admin());

CREATE POLICY payments_insert ON payments
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY payments_admin_update ON payments
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- SUBSCRIPTIONS
-- ============================================================================
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY subscriptions_select ON subscriptions
    FOR SELECT USING (user_id = auth.uid() OR is_admin());

CREATE POLICY subscriptions_insert ON subscriptions
    FOR INSERT WITH CHECK (is_admin()); -- only system can create

CREATE POLICY subscriptions_admin_update ON subscriptions
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- FEATURE FLAGS
-- ============================================================================
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;

CREATE POLICY feature_flags_select ON feature_flags
    FOR SELECT USING (true); -- all users can read flags

CREATE POLICY feature_flags_admin_insert ON feature_flags
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY feature_flags_admin_update ON feature_flags
    FOR UPDATE USING (is_admin());

CREATE POLICY feature_flags_admin_delete ON feature_flags
    FOR DELETE USING (is_admin());

-- ============================================================================
-- SERVICE PARTNERS
-- ============================================================================
ALTER TABLE service_partners ENABLE ROW LEVEL SECURITY;

CREATE POLICY service_partners_select ON service_partners
    FOR SELECT USING (true); -- public directory

CREATE POLICY service_partners_admin_insert ON service_partners
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY service_partners_admin_update ON service_partners
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- SERVICE BOOKINGS
-- ============================================================================
ALTER TABLE service_bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY service_bookings_select ON service_bookings
    FOR SELECT USING (user_id = auth.uid() OR is_admin());

CREATE POLICY service_bookings_insert ON service_bookings
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY service_bookings_update ON service_bookings
    FOR UPDATE USING (user_id = auth.uid() OR is_admin());

-- ============================================================================
-- SERVICE REVIEWS
-- ============================================================================
ALTER TABLE service_reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY service_reviews_select ON service_reviews
    FOR SELECT USING (true); -- public

CREATE POLICY service_reviews_insert ON service_reviews
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY service_reviews_update ON service_reviews
    FOR UPDATE USING (user_id = auth.uid());

-- ============================================================================
-- CITY GUIDES
-- ============================================================================
ALTER TABLE city_guides ENABLE ROW LEVEL SECURITY;

CREATE POLICY city_guides_select ON city_guides
    FOR SELECT USING (true); -- public

CREATE POLICY city_guides_admin_insert ON city_guides
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY city_guides_admin_update ON city_guides
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- EVENTS
-- ============================================================================
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

CREATE POLICY events_select ON events
    FOR SELECT USING (true); -- public

CREATE POLICY events_insert ON events
    FOR INSERT WITH CHECK (organizer_id = auth.uid() OR is_admin());

CREATE POLICY events_update ON events
    FOR UPDATE USING (organizer_id = auth.uid() OR is_admin());

CREATE POLICY events_delete ON events
    FOR DELETE USING (organizer_id = auth.uid() OR is_admin());

-- ============================================================================
-- EVENT RSVPS
-- ============================================================================
ALTER TABLE event_rsvps ENABLE ROW LEVEL SECURITY;

CREATE POLICY event_rsvps_select ON event_rsvps
    FOR SELECT USING (user_id = auth.uid() OR is_admin());

CREATE POLICY event_rsvps_insert ON event_rsvps
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY event_rsvps_update ON event_rsvps
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY event_rsvps_delete ON event_rsvps
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================================
-- REFERRALS
-- ============================================================================
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;

CREATE POLICY referrals_select ON referrals
    FOR SELECT USING (referrer_id = auth.uid() OR referee_id = auth.uid() OR is_admin());

CREATE POLICY referrals_insert ON referrals
    FOR INSERT WITH CHECK (referrer_id = auth.uid());

CREATE POLICY referrals_admin_update ON referrals
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- AMBASSADORS
-- ============================================================================
ALTER TABLE ambassadors ENABLE ROW LEVEL SECURITY;

CREATE POLICY ambassadors_select ON ambassadors
    FOR SELECT USING (user_id = auth.uid() OR is_admin());

CREATE POLICY ambassadors_insert ON ambassadors
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY ambassadors_update ON ambassadors
    FOR UPDATE USING (user_id = auth.uid() OR is_admin());

-- ============================================================================
-- CORPORATE ACCOUNTS
-- ============================================================================
ALTER TABLE corporate_accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY corporate_accounts_select ON corporate_accounts
    FOR SELECT USING (is_admin());

CREATE POLICY corporate_accounts_insert ON corporate_accounts
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY corporate_accounts_update ON corporate_accounts
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- COLLEGE ACCOUNTS
-- ============================================================================
ALTER TABLE college_accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY college_accounts_select ON college_accounts
    FOR SELECT USING (is_admin());

CREATE POLICY college_accounts_insert ON college_accounts
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY college_accounts_update ON college_accounts
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- OPERATOR ACCOUNTS
-- ============================================================================
ALTER TABLE operator_accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY operator_accounts_select ON operator_accounts
    FOR SELECT USING (is_admin());

CREATE POLICY operator_accounts_insert ON operator_accounts
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY operator_accounts_update ON operator_accounts
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- BROKER ACCOUNTS
-- ============================================================================
ALTER TABLE broker_accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY broker_accounts_select ON broker_accounts
    FOR SELECT USING (is_admin());

CREATE POLICY broker_accounts_insert ON broker_accounts
    FOR INSERT WITH CHECK (is_admin());

CREATE POLICY broker_accounts_update ON broker_accounts
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- NOTIFICATIONS
-- ============================================================================
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY notifications_select ON notifications
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY notifications_insert ON notifications
    FOR INSERT WITH CHECK (is_admin()); -- only system/edge functions

CREATE POLICY notifications_update ON notifications
    FOR UPDATE USING (user_id = auth.uid()); -- user can mark as read

-- ============================================================================
-- NOTIFICATION PREFERENCES
-- ============================================================================
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY notification_preferences_select ON notification_preferences
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY notification_preferences_insert ON notification_preferences
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY notification_preferences_update ON notification_preferences
    FOR UPDATE USING (user_id = auth.uid());

-- ============================================================================
-- PUSH TOKENS
-- ============================================================================
ALTER TABLE push_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY push_tokens_select ON push_tokens
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY push_tokens_insert ON push_tokens
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY push_tokens_update ON push_tokens
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY push_tokens_delete ON push_tokens
    FOR DELETE USING (user_id = auth.uid());

-- ============================================================================
-- ADMIN USERS
-- ============================================================================
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY admin_users_select ON admin_users
    FOR SELECT USING (is_admin());

CREATE POLICY admin_users_insert ON admin_users
    FOR INSERT WITH CHECK (
        EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid() AND role = 'superadmin')
    );

CREATE POLICY admin_users_update ON admin_users
    FOR UPDATE USING (
        EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid() AND role = 'superadmin')
    );

-- ============================================================================
-- MODERATION QUEUE
-- ============================================================================
ALTER TABLE moderation_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY moderation_queue_select ON moderation_queue
    FOR SELECT USING (is_admin());

CREATE POLICY moderation_queue_insert ON moderation_queue
    FOR INSERT WITH CHECK (true); -- system can insert, also user reports

CREATE POLICY moderation_queue_update ON moderation_queue
    FOR UPDATE USING (is_admin());

-- ============================================================================
-- DISPUTES
-- ============================================================================
ALTER TABLE disputes ENABLE ROW LEVEL SECURITY;

CREATE POLICY disputes_select ON disputes
    FOR SELECT USING (raised_by = auth.uid() OR against_id = auth.uid() OR is_admin());

CREATE POLICY disputes_insert ON disputes
    FOR INSERT WITH CHECK (raised_by = auth.uid());

CREATE POLICY disputes_update ON disputes
    FOR UPDATE USING (is_admin()); -- only admins can resolve

-- ============================================================================
-- AUDIT LOGS
-- ============================================================================
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY audit_logs_select ON audit_logs
    FOR SELECT USING (is_admin());

CREATE POLICY audit_logs_insert ON audit_logs
    FOR INSERT WITH CHECK (true); -- system insert-only

-- ============================================================================
-- ANALYTICS EVENTS
-- ============================================================================
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY analytics_events_select ON analytics_events
    FOR SELECT USING (is_admin());

CREATE POLICY analytics_events_insert ON analytics_events
    FOR INSERT WITH CHECK (true); -- any authenticated user can log events
