import React, { useState } from 'react';
import {
  Smartphone,
  Heart,
  X,
  Star,
  Sparkles,
  ShieldCheck,
  MessageSquare,
  Home,
  CheckCircle2,
  Calendar,
  AlertTriangle,
  Send,
  Phone,
  MapPin,
  IndianRupee,
  Lock,
  Eye,
  Sliders,
  ChevronRight,
  Flame,
  Volume2,
  UserCheck
} from 'lucide-react';

interface MockProfile {
  id: string;
  name: string;
  age: number;
  gender: string;
  occupation: string;
  locality: string;
  budget: string;
  moveIn: string;
  compatScore: number;
  photoUrl: string;
  bio: string;
  compatibleTraits: string[];
  watchOutTraits: string[];
  lifestyle: {
    sleep: string;
    food: string;
    cleanliness: string;
    smoking: string;
    guests: string;
    wfh: string;
  };
}

const mockProfiles: MockProfile[] = [
  {
    id: '1',
    name: 'Ananya Deshmukh',
    age: 24,
    gender: 'Female',
    occupation: 'UX Designer @ Swiggy',
    locality: 'Bandra West, Mumbai',
    budget: '₹22,000 / mo',
    moveIn: 'Dec 1, 2026',
    compatScore: 94,
    photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&auto=format&fit=crop&q=80',
    bio: 'Looking for a peaceful, sunlit 2 BHK near Bandra station. Clean freak, weekend baker, plant mom.',
    compatibleTraits: ['Early Riser (10 PM - 6 AM)', 'Vegetarian Kitchen', 'High Cleanliness', 'Splitwise Pro'],
    watchOutTraits: ['Cat lover (has a 1-yr tabby)'],
    lifestyle: {
      sleep: '10:30 PM - 6:30 AM',
      food: 'Pure Vegetarian',
      cleanliness: 'Spotless daily',
      smoking: 'Strict No',
      guests: 'Weekends only, heads-up first',
      wfh: 'Hybrid (3 days home)'
    }
  },
  {
    id: '2',
    name: 'Rohan Mehta',
    age: 26,
    gender: 'Male',
    occupation: 'Product Manager @ Zepto',
    locality: 'Andheri West, Mumbai',
    budget: '₹26,000 / mo',
    moveIn: 'Immediate',
    compatScore: 88,
    photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&auto=format&fit=crop&q=80',
    bio: 'Moving from Bengaluru. Love board games, football on weekends. Easy-going, respects personal space.',
    compatibleTraits: ['Equal Bill Splitting', 'Zero Smoking', 'Gym regular'],
    watchOutTraits: ['Sleeps after midnight'],
    lifestyle: {
      sleep: '12:30 AM - 8:00 AM',
      food: 'Eggetarian',
      cleanliness: 'Clean common areas',
      smoking: 'Non-smoker',
      guests: 'Occasional friends',
      wfh: 'Full Office'
    }
  },
  {
    id: '3',
    name: 'Pooja Nair',
    age: 25,
    gender: 'Female',
    occupation: 'Fintech Analyst @ Morgan Stanley',
    locality: 'Powai, Mumbai',
    budget: '₹28,000 / mo',
    moveIn: 'Jan 15, 2027',
    compatScore: 82,
    photoUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600&auto=format&fit=crop&q=80',
    bio: 'Finance nerd by day, indie music listener by night. Looking for a neat flatmate in Hiranandani.',
    compatibleTraits: ['Quiet Hours strictly 11 PM', 'Pays on 1st of month', 'Non-smoker'],
    watchOutTraits: ['High AC usage in summer'],
    lifestyle: {
      sleep: '11:00 PM - 7:00 AM',
      food: 'Non-Vegetarian',
      cleanliness: 'Shared maid service',
      smoking: 'Strict No',
      guests: 'Rarely',
      wfh: 'Hybrid (2 days home)'
    }
  }
];

export const MobileAppSimulator: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'discover' | 'quiz' | 'chat' | 'hub' | 'trust'>('discover');
  const [cardIndex, setCardIndex] = useState(0);
  const [swipedAction, setSwipedAction] = useState<string | null>(null);
  const [chatMessages, setChatMessages] = useState<Array<{ sender: string; text: string; time: string; type?: string }>>([
    { sender: 'system', text: 'You matched with Ananya Deshmukh! 94% Compatibility.', time: '10:00 AM' },
    { sender: 'them', text: 'Hey! Loved your profile. You mentioned looking for a 2BHK in Bandra West?', time: '10:02 AM' },
    { sender: 'me', text: 'Hey Ananya! Yes, exactly. Near Carter Road or Pali Hill. How soon are you planning to move?', time: '10:05 AM' }
  ]);
  const [inputMessage, setInputMessage] = useState('');
  const [phoneRevealed, setPhoneRevealed] = useState(false);
  const [womenOnlyMode, setWomenOnlyMode] = useState(false);
  const [settledExpenses, setSettledExpenses] = useState<Record<string, boolean>>({});
  const [completedChores, setCompletedChores] = useState<Record<string, boolean>>({});
  const [showUPISheet, setShowUPISheet] = useState<string | null>(null);

  // Questionnaire state
  const [quizAnswers, setQuizAnswers] = useState<Record<number, string>>({
    1: '10 PM - 12 AM',
    2: '7 - 9 AM',
    3: 'Clean enough',
    4: 'Wash within few hours',
    5: 'Vegetarian'
  });
  const [dealBreakers, setDealBreakers] = useState<Record<number, string>>({
    3: 'important',
    5: 'deal_breaker'
  });

  const currentProfile = mockProfiles[cardIndex % mockProfiles.length];

  const handleSwipe = (direction: 'left' | 'right' | 'super') => {
    setSwipedAction(direction);
    setTimeout(() => {
      setCardIndex(prev => prev + 1);
      setSwipedAction(null);
    }, 300);
  };

  const handleSendMessage = () => {
    if (!inputMessage.trim()) return;
    const newMsg = { sender: 'me', text: inputMessage, time: 'Just now' };
    setChatMessages(prev => [...prev, newMsg]);
    setInputMessage('');

    // AI or counterpart auto-reply simulation
    setTimeout(() => {
      setChatMessages(prev => [
        ...prev,
        {
          sender: 'them',
          text: 'Sounds great! I checked a flat on Pali Hill yesterday. Want to schedule a public meet at Blue Tokai Cafe Bandra this Saturday?',
          time: 'Just now'
        }
      ]);
    }, 1000);
  };

  return (
    <div className="flex flex-col lg:flex-row items-center justify-center gap-8 py-6">
      {/* Feature Guide Panel */}
      <div className="w-full lg:w-96 space-y-4">
        <div className="bg-white p-5 rounded-2xl shadow-sm border border-slate-200">
          <div className="flex items-center gap-2 text-teal-600 font-semibold mb-1">
            <Smartphone className="w-5 h-5" />
            <span>Interactive FlatFit Mobile App</span>
          </div>
          <p className="text-xs text-slate-500 mb-4">
            Test the complete end-to-end mobile user journey right here in your browser.
          </p>

          <div className="space-y-2">
            {[
              { id: 'discover', title: '1. Discover & Match', desc: 'Tinder-style swipe feed, 0-100 compatibility rating & lifestyle traits' },
              { id: 'quiz', title: '2. Lifestyle Quiz', desc: '20 questions, neutral lifestyle filtering, Deal-breaker weights' },
              { id: 'chat', title: '3. Realtime Chat & Meet', desc: 'Icebreakers, masked phone unmasking, public cafe scheduler' },
              { id: 'hub', title: '4. Living Together Hub', desc: 'Shared flat notice board, exact-paise UPI splitter, chore rotation' },
              { id: 'trust', title: '5. Trust & Safety', desc: '0-100 trust score gauge, Digilocker KYC, Women-Only mode, SOS' }
            ].map(tab => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id as any)}
                className={`w-full text-left p-3 rounded-xl transition-all ${
                  activeTab === tab.id
                    ? 'bg-teal-50 border-2 border-teal-500 text-teal-900 shadow-xs'
                    : 'bg-slate-50 border border-slate-100 text-slate-700 hover:bg-slate-100'
                }`}
              >
                <div className="font-medium text-sm flex items-center justify-between">
                  <span>{tab.title}</span>
                  <ChevronRight className={`w-4 h-4 ${activeTab === tab.id ? 'text-teal-600' : 'text-slate-400'}`} />
                </div>
                <div className="text-xs text-slate-500 mt-0.5">{tab.desc}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Live Metrics Ticker */}
        <div className="bg-gradient-to-br from-indigo-900 to-slate-900 text-white p-5 rounded-2xl shadow-sm">
          <div className="text-xs uppercase tracking-wider text-indigo-300 font-semibold mb-2">Live Session State</div>
          <div className="grid grid-cols-2 gap-3 text-xs">
            <div className="bg-white/10 p-2.5 rounded-lg">
              <span className="text-slate-400 block">Trust Score</span>
              <span className="text-lg font-bold text-teal-400">92 / 100</span>
            </div>
            <div className="bg-white/10 p-2.5 rounded-lg">
              <span className="text-slate-400 block">Women-Only Mode</span>
              <span className={`text-sm font-bold ${womenOnlyMode ? 'text-pink-400' : 'text-slate-400'}`}>
                {womenOnlyMode ? 'ACTIVE' : 'OFF'}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Phone Mockup Frame */}
      <div className="relative w-[385px] h-[780px] bg-slate-900 rounded-[48px] p-3 shadow-2xl border-4 border-slate-700 ring-12 ring-slate-800 flex flex-col overflow-hidden">
        {/* Dynamic Island / Speaker Notch */}
        <div className="absolute top-4 left-1/2 -translate-x-1/2 w-32 h-6 bg-black rounded-full z-50 flex items-center justify-center">
          <div className="w-3 h-3 bg-slate-900 rounded-full border border-slate-800 ml-auto mr-3"></div>
        </div>

        {/* Mobile Screen Container */}
        <div className="relative flex-1 bg-slate-50 rounded-[38px] overflow-hidden flex flex-col">
          {/* Status Bar */}
          <div className="h-11 bg-white px-6 flex items-center justify-between text-xs font-semibold text-slate-800 border-b border-slate-100 z-40">
            <span>9:41</span>
            <div className="flex items-center gap-1.5">
              <span className="text-[10px] text-teal-600 font-bold">5G</span>
              <div className="w-5 h-2.5 border border-slate-800 rounded-xs p-0.5">
                <div className="h-full bg-slate-800 rounded-xs w-3/4"></div>
              </div>
            </div>
          </div>

          {/* Screen Content Body */}
          <div className="flex-1 overflow-y-auto pb-16">
            {/* 1. DISCOVER TAB */}
            {activeTab === 'discover' && (
              <div className="p-3 h-full flex flex-col justify-between">
                {/* Header */}
                <div className="flex items-center justify-between px-1 mb-2">
                  <div>
                    <h2 className="text-lg font-black tracking-tight text-slate-900 flex items-center gap-1.5">
                      <span className="text-teal-600">Flat</span>Fit
                    </h2>
                    <p className="text-[11px] text-slate-500">Mumbai • 15km radius</p>
                  </div>
                  <button
                    onClick={() => setWomenOnlyMode(!womenOnlyMode)}
                    className={`px-2.5 py-1 rounded-full text-[11px] font-bold flex items-center gap-1 border transition-all ${
                      womenOnlyMode
                        ? 'bg-pink-100 text-pink-700 border-pink-300'
                        : 'bg-slate-100 text-slate-600 border-slate-200'
                    }`}
                  >
                    ♀ Women-Only
                  </button>
                </div>

                {/* Swipe Card */}
                <div className="relative flex-1 rounded-2xl overflow-hidden shadow-md bg-white border border-slate-200 flex flex-col">
                  {/* Card Image */}
                  <div className="relative h-64 w-full">
                    <img
                      src={currentProfile.photoUrl}
                      alt={currentProfile.name}
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/20" />

                    {/* Compatibility Badge */}
                    <div className="absolute top-3 right-3 bg-teal-500 text-white px-3 py-1.5 rounded-full font-bold text-xs flex items-center gap-1 shadow-lg ring-2 ring-white/50">
                      <Sparkles className="w-3.5 h-3.5" />
                      <span>{currentProfile.compatScore}% Match</span>
                    </div>

                    {/* Basic Info on Photo */}
                    <div className="absolute bottom-3 left-3 right-3 text-white">
                      <div className="flex items-baseline gap-2">
                        <span className="text-xl font-bold">{currentProfile.name}</span>
                        <span className="text-sm opacity-90">{currentProfile.age}</span>
                      </div>
                      <div className="text-xs text-slate-200 flex items-center gap-1 mt-0.5">
                        <MapPin className="w-3 h-3 text-teal-400" />
                        <span>{currentProfile.locality}</span>
                        <span className="mx-1">•</span>
                        <IndianRupee className="w-3 h-3" />
                        <span>{currentProfile.budget}</span>
                      </div>
                    </div>
                  </div>

                  {/* Card Details */}
                  <div className="p-3 space-y-2.5 flex-1 flex flex-col justify-between">
                    <div>
                      <p className="text-xs text-slate-600 line-clamp-2 italic mb-2">"{currentProfile.bio}"</p>

                      {/* Compatible Traits */}
                      <div className="space-y-1">
                        <div className="text-[10px] font-bold uppercase tracking-wider text-teal-700">Compatible On:</div>
                        <div className="flex flex-wrap gap-1">
                          {currentProfile.compatibleTraits.map((trait, i) => (
                            <span key={i} className="text-[10px] bg-teal-50 text-teal-700 px-2 py-0.5 rounded-md font-medium border border-teal-100 flex items-center gap-1">
                              <CheckCircle2 className="w-2.5 h-2.5 text-teal-600" />
                              {trait}
                            </span>
                          ))}
                        </div>
                      </div>

                      {/* Watch-out trait */}
                      <div className="mt-2">
                        <div className="text-[10px] font-bold uppercase tracking-wider text-amber-700">Watch Out:</div>
                        <div className="flex flex-wrap gap-1">
                          {currentProfile.watchOutTraits.map((trait, i) => (
                            <span key={i} className="text-[10px] bg-amber-50 text-amber-700 px-2 py-0.5 rounded-md font-medium border border-amber-200 flex items-center gap-1">
                              <AlertTriangle className="w-2.5 h-2.5 text-amber-600" />
                              {trait}
                            </span>
                          ))}
                        </div>
                      </div>
                    </div>

                    {/* Action Buttons */}
                    <div className="flex items-center justify-center gap-4 pt-1 border-t border-slate-100">
                      <button
                        onClick={() => handleSwipe('left')}
                        className="w-12 h-12 rounded-full bg-slate-100 text-slate-600 hover:bg-rose-50 hover:text-rose-600 border border-slate-200 flex items-center justify-center transition-all shadow-sm active:scale-95"
                      >
                        <X className="w-6 h-6" />
                      </button>
                      <button
                        onClick={() => handleSwipe('super')}
                        className="w-10 h-10 rounded-full bg-amber-50 text-amber-600 hover:bg-amber-100 border border-amber-200 flex items-center justify-center transition-all active:scale-95"
                      >
                        <Star className="w-5 h-5 fill-amber-500" />
                      </button>
                      <button
                        onClick={() => {
                          handleSwipe('right');
                          setActiveTab('chat');
                        }}
                        className="w-12 h-12 rounded-full bg-teal-600 text-white hover:bg-teal-700 flex items-center justify-center transition-all shadow-md active:scale-95"
                      >
                        <Heart className="w-6 h-6 fill-white" />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* 2. QUIZ TAB */}
            {activeTab === 'quiz' && (
              <div className="p-4 space-y-4">
                <div className="border-b border-slate-200 pb-2">
                  <div className="flex items-center justify-between">
                    <span className="text-xs font-bold text-teal-600 uppercase tracking-wider">Lifestyle Questionnaire</span>
                    <span className="text-xs bg-teal-100 text-teal-800 px-2 py-0.5 rounded-full font-bold">5 / 20 Completed</span>
                  </div>
                  <h3 className="text-sm font-bold text-slate-800 mt-1">Neutral Lifestyle Quiz (No Religion/Caste)</h3>
                </div>

                {/* Question Cards */}
                <div className="space-y-3">
                  {[
                    {
                      id: 1,
                      topic: 'Sleep Schedule',
                      question: 'What time do you usually sleep?',
                      options: ['Before 10 PM', '10 PM - 12 AM', 'After midnight', 'Irregular']
                    },
                    {
                      id: 3,
                      topic: 'Cleanliness',
                      question: 'How clean do you keep common areas?',
                      options: ['Spotless always', 'Clean enough', 'Clean on weekends', 'Pretty relaxed']
                    },
                    {
                      id: 5,
                      topic: 'Food Preference',
                      question: 'Your kitchen & food preference?',
                      options: ['Pure Vegetarian', 'Eggetarian', 'Non-Veg', 'Jain', 'Vegan']
                    }
                  ].map(q => (
                    <div key={q.id} className="bg-white p-3.5 rounded-xl border border-slate-200 shadow-2xs space-y-2">
                      <div className="flex items-center justify-between">
                        <span className="text-[11px] font-bold text-indigo-600">{q.topic}</span>
                        {/* Importance Pill */}
                        <div className="flex gap-1 text-[9px]">
                          {(['deal_breaker', 'important', 'nice_to_have'] as const).map(imp => (
                            <button
                              key={imp}
                              onClick={() => setDealBreakers(prev => ({ ...prev, [q.id]: imp }))}
                              className={`px-1.5 py-0.5 rounded-sm font-bold capitalize ${
                                dealBreakers[q.id] === imp
                                  ? imp === 'deal_breaker'
                                    ? 'bg-rose-500 text-white'
                                    : 'bg-teal-600 text-white'
                                  : 'bg-slate-100 text-slate-500'
                              }`}
                            >
                              {imp.replace('_', ' ')}
                            </button>
                          ))}
                        </div>
                      </div>

                      <p className="text-xs font-medium text-slate-800">{q.question}</p>

                      <div className="grid grid-cols-2 gap-1.5">
                        {q.options.map(opt => (
                          <button
                            key={opt}
                            onClick={() => setQuizAnswers(prev => ({ ...prev, [q.id]: opt }))}
                            className={`p-2 text-[11px] rounded-lg font-medium text-left border transition-all ${
                              quizAnswers[q.id] === opt
                                ? 'bg-teal-50 border-teal-500 text-teal-800 font-bold'
                                : 'bg-slate-50 border-slate-200 text-slate-700 hover:bg-slate-100'
                            }`}
                          >
                            {opt}
                          </button>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>

                <button
                  onClick={() => setActiveTab('discover')}
                  className="w-full py-2.5 bg-teal-600 text-white text-xs font-bold rounded-xl shadow-xs"
                >
                  Save & Recompute Compatibility (Top Matches)
                </button>
              </div>
            )}

            {/* 3. CHAT TAB */}
            {activeTab === 'chat' && (
              <div className="h-full flex flex-col justify-between">
                {/* Chat Header */}
                <div className="bg-white p-3 border-b border-slate-200 flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <img
                      src={mockProfiles[0].photoUrl}
                      alt="Ananya"
                      className="w-9 h-9 rounded-full object-cover border border-teal-500"
                    />
                    <div>
                      <div className="text-xs font-bold text-slate-900 flex items-center gap-1">
                        Ananya Deshmukh
                        <ShieldCheck className="w-3.5 h-3.5 text-teal-600" />
                      </div>
                      <div className="text-[10px] text-teal-600 font-semibold">94% Compatibility</div>
                    </div>
                  </div>

                  {/* Masked Phone Reveal */}
                  <button
                    onClick={() => setPhoneRevealed(!phoneRevealed)}
                    className="text-[10px] bg-slate-100 hover:bg-slate-200 text-slate-700 px-2 py-1 rounded-lg border border-slate-300 flex items-center gap-1 font-semibold"
                  >
                    {phoneRevealed ? (
                      <>
                        <Phone className="w-3 h-3 text-teal-600" />
                        +91 98201 44192
                      </>
                    ) : (
                      <>
                        <Lock className="w-3 h-3 text-amber-600" />
                        Reveal Phone
                      </>
                    )}
                  </button>
                </div>

                {/* AI Conversation Starter Pill */}
                <div className="bg-indigo-50 border-b border-indigo-100 px-3 py-1.5 flex items-center gap-1.5 text-[10px] text-indigo-700">
                  <Sparkles className="w-3.5 h-3.5 text-indigo-600 shrink-0" />
                  <span><strong>AI Starter:</strong> You both wake up early and love clean kitchens!</span>
                </div>

                {/* Messages Body */}
                <div className="p-3 space-y-2 flex-1 overflow-y-auto">
                  {chatMessages.map((msg, i) => (
                    <div
                      key={i}
                      className={`flex flex-col ${
                        msg.sender === 'system'
                          ? 'items-center my-1'
                          : msg.sender === 'me'
                          ? 'items-end'
                          : 'items-start'
                      }`}
                    >
                      {msg.sender === 'system' ? (
                        <span className="text-[10px] bg-slate-200 text-slate-600 px-2 py-0.5 rounded-full font-medium">
                          {msg.text}
                        </span>
                      ) : (
                        <div
                          className={`max-w-[78%] p-2.5 rounded-2xl text-xs ${
                            msg.sender === 'me'
                              ? 'bg-teal-600 text-white rounded-tr-xs'
                              : 'bg-white border border-slate-200 text-slate-800 rounded-tl-xs shadow-2xs'
                          }`}
                        >
                          {msg.text}
                          <span className={`block text-[9px] mt-1 text-right ${msg.sender === 'me' ? 'text-teal-200' : 'text-slate-400'}`}>
                            {msg.time}
                          </span>
                        </div>
                      )}
                    </div>
                  ))}
                </div>

                {/* Public Meet Scheduler Shortcut */}
                <div className="px-3 py-1 bg-amber-50 border-t border-amber-200 flex items-center justify-between text-[10px] text-amber-800">
                  <span>📍 Recommended Safe Meet: Blue Tokai Cafe, Bandra</span>
                  <button className="font-bold underline text-amber-900">Schedule</button>
                </div>

                {/* Input Bar */}
                <div className="p-2 bg-white border-t border-slate-200 flex items-center gap-1.5">
                  <input
                    type="text"
                    value={inputMessage}
                    onChange={e => setInputMessage(e.target.value)}
                    onKeyDown={e => e.key === 'Enter' && handleSendMessage()}
                    placeholder="Type a message..."
                    className="flex-1 text-xs bg-slate-100 rounded-full px-3 py-2 outline-none focus:ring-1 focus:ring-teal-500"
                  />
                  <button
                    onClick={handleSendMessage}
                    className="w-8 h-8 rounded-full bg-teal-600 text-white flex items-center justify-center shrink-0 active:scale-95"
                  >
                    <Send className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            )}

            {/* 4. HOUSE HUB TAB */}
            {activeTab === 'hub' && (
              <div className="p-3 space-y-3">
                <div className="bg-gradient-to-r from-teal-600 to-indigo-700 text-white p-3.5 rounded-2xl shadow-sm">
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-[10px] uppercase font-bold tracking-wider text-teal-200">Shared House Hub</span>
                    <span className="text-[10px] bg-white/20 px-2 py-0.5 rounded-full">Flat #301</span>
                  </div>
                  <h3 className="text-base font-extrabold">Sunshine Apartments, Bandra</h3>
                  <p className="text-xs text-teal-100 mt-0.5">3 Flatmates • ₹24,000 / person</p>
                </div>

                {/* Expense Splitter Section */}
                <div className="bg-white p-3 rounded-xl border border-slate-200 shadow-2xs space-y-2">
                  <div className="flex items-center justify-between">
                    <h4 className="text-xs font-bold text-slate-900 flex items-center gap-1">
                      <IndianRupee className="w-3.5 h-3.5 text-teal-600" />
                      Shared Expenses (Exact Paise)
                    </h4>
                    <span className="text-[10px] text-slate-500">Auto-balanced</span>
                  </div>

                  <div className="space-y-1.5 text-xs">
                    {[
                      { id: 'exp-1', title: 'WiFi Broadband (JioFiber)', amount: '₹1,499.00', yourShare: '₹499.66', paidBy: 'Rohan' },
                      { id: 'exp-2', title: 'Cook Monthly Salary', amount: '₹9,000.00', yourShare: '₹3,000.00', paidBy: 'Ananya' },
                      { id: 'exp-3', title: 'Nature Basket Groceries', amount: '₹2,340.50', yourShare: '₹780.17', paidBy: 'You' }
                    ].map(exp => (
                      <div key={exp.id} className="p-2 bg-slate-50 rounded-lg flex items-center justify-between border border-slate-100">
                        <div>
                          <div className="font-semibold text-slate-800">{exp.title}</div>
                          <div className="text-[10px] text-slate-500">Paid by {exp.paidBy} • Total {exp.amount}</div>
                        </div>
                        <div className="text-right">
                          <div className="font-bold text-slate-900">{exp.yourShare}</div>
                          <button
                            onClick={() => {
                              setSettledExpenses(prev => ({ ...prev, [exp.id]: true }));
                              setShowUPISheet(exp.title);
                            }}
                            className={`text-[9px] px-2 py-0.5 rounded font-bold ${
                              settledExpenses[exp.id]
                                ? 'bg-emerald-100 text-emerald-800'
                                : 'bg-teal-600 text-white'
                            }`}
                          >
                            {settledExpenses[exp.id] ? 'Settled ✓' : 'Pay via UPI'}
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>

                  {showUPISheet && (
                    <div className="p-2.5 bg-emerald-50 border border-emerald-200 rounded-lg text-xs text-emerald-800 flex items-center justify-between">
                      <div>
                        <strong>UPI Intent Triggered:</strong>
                        <div className="text-[10px] text-emerald-700">upi://pay?pa=flatfit@icici&am=499.66</div>
                      </div>
                      <button onClick={() => setShowUPISheet(null)} className="text-[10px] font-bold underline">
                        Dismiss
                      </button>
                    </div>
                  )}
                </div>

                {/* Chore Fairness Planner */}
                <div className="bg-white p-3 rounded-xl border border-slate-200 shadow-2xs space-y-2">
                  <div className="flex items-center justify-between">
                    <h4 className="text-xs font-bold text-slate-900 flex items-center gap-1">
                      <CheckCircle2 className="w-3.5 h-3.5 text-indigo-600" />
                      Chore Fairness Planner
                    </h4>
                    <span className="text-[10px] text-indigo-600 font-bold">Rotation: Weekly</span>
                  </div>

                  <div className="space-y-1.5 text-xs">
                    {[
                      { id: 'ch-1', chore: 'Take out Kitchen Trash', assignee: 'You', due: 'Today, 8 PM' },
                      { id: 'ch-2', chore: 'Wipe Living Room Counters', assignee: 'Ananya', due: 'Tomorrow' },
                      { id: 'ch-3', chore: 'Water Balcony Plants', assignee: 'Rohan', due: 'Friday' }
                    ].map(ch => (
                      <div key={ch.id} className="p-2 bg-slate-50 rounded-lg flex items-center justify-between border border-slate-100">
                        <div className="flex items-center gap-2">
                          <input
                            type="checkbox"
                            checked={!!completedChores[ch.id]}
                            onChange={e => setCompletedChores(prev => ({ ...prev, [ch.id]: e.target.checked }))}
                            className="w-4 h-4 text-teal-600 rounded"
                          />
                          <div>
                            <span className={`font-medium ${completedChores[ch.id] ? 'line-through text-slate-400' : 'text-slate-800'}`}>
                              {ch.chore}
                            </span>
                            <div className="text-[10px] text-slate-500">{ch.assignee} • Due {ch.due}</div>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* House Memory & Rules */}
                <div className="p-2.5 bg-slate-100 rounded-xl text-xs text-slate-600 flex items-center justify-between">
                  <span>🌙 <strong>Quiet Hours:</strong> 11:00 PM – 7:00 AM</span>
                  <span className="text-[10px] bg-slate-200 px-2 py-0.5 rounded font-bold text-slate-700">Active</span>
                </div>
              </div>
            )}

            {/* 5. TRUST & SAFETY TAB */}
            {activeTab === 'trust' && (
              <div className="p-4 space-y-4">
                <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm text-center">
                  <div className="w-16 h-16 mx-auto rounded-full bg-teal-50 border-4 border-teal-500 flex items-center justify-center text-teal-700 font-black text-xl mb-2">
                    92
                  </div>
                  <h3 className="text-sm font-bold text-slate-900">Your Trust Score</h3>
                  <p className="text-xs text-slate-500 mt-0.5">High Trust • Verified Member</p>
                </div>

                {/* Verification Badges */}
                <div className="bg-white p-3.5 rounded-xl border border-slate-200 shadow-2xs space-y-2">
                  <h4 className="text-xs font-bold text-slate-800 uppercase tracking-wider">Verification Checklist</h4>
                  <div className="space-y-2 text-xs">
                    <div className="flex items-center justify-between p-2 bg-emerald-50 border border-emerald-200 rounded-lg text-emerald-900">
                      <div className="flex items-center gap-2">
                        <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                        <span>Phone Number (+91 Verified)</span>
                      </div>
                      <span className="text-[10px] font-bold">+10 pts</span>
                    </div>
                    <div className="flex items-center justify-between p-2 bg-emerald-50 border border-emerald-200 rounded-lg text-emerald-900">
                      <div className="flex items-center gap-2">
                        <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                        <span>Government ID (DigiLocker Mock)</span>
                      </div>
                      <span className="text-[10px] font-bold">+30 pts</span>
                    </div>
                    <div className="flex items-center justify-between p-2 bg-emerald-50 border border-emerald-200 rounded-lg text-emerald-900">
                      <div className="flex items-center gap-2">
                        <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                        <span>Corporate Email (@swiggy.in)</span>
                      </div>
                      <span className="text-[10px] font-bold">+15 pts</span>
                    </div>
                  </div>
                </div>

                {/* Safety SOS Center */}
                <div className="bg-rose-50 border border-rose-200 p-3.5 rounded-xl space-y-2 text-rose-900">
                  <div className="flex items-center gap-2 font-bold text-xs">
                    <AlertTriangle className="w-4 h-4 text-rose-600" />
                    <span>Emergency Safety Center</span>
                  </div>
                  <p className="text-[11px] text-rose-700">
                    One-tap SOS broadcasts your live GPS location to your 3 trusted contacts during your first meet or move-in.
                  </p>
                  <button
                    onClick={() => alert('SOS Triggered (Simulated): Live location shared with 3 Emergency Contacts and flatmate verification desk.')}
                    className="w-full py-2 bg-rose-600 hover:bg-rose-700 text-white font-bold text-xs rounded-lg shadow-xs active:scale-95 transition-all"
                  >
                    🚨 Trigger Emergency SOS (Test)
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* Bottom Navigation Bar */}
          <div className="absolute bottom-0 left-0 right-0 h-14 bg-white border-t border-slate-200 flex items-center justify-around px-2 z-40">
            {[
              { id: 'discover', label: 'Discover', icon: Flame },
              { id: 'quiz', label: 'Quiz', icon: Sliders },
              { id: 'chat', label: 'Chat', icon: MessageSquare },
              { id: 'hub', label: 'Hub', icon: Home },
              { id: 'trust', label: 'Trust', icon: ShieldCheck }
            ].map(nav => {
              const Icon = nav.icon;
              const isActive = activeTab === nav.id;
              return (
                <button
                  key={nav.id}
                  onClick={() => setActiveTab(nav.id as any)}
                  className={`flex flex-col items-center justify-center flex-1 py-1 transition-all ${
                    isActive ? 'text-teal-600 font-bold' : 'text-slate-400 hover:text-slate-600'
                  }`}
                >
                  <Icon className={`w-5 h-5 ${isActive ? 'stroke-[2.5px]' : 'stroke-[1.8px]'}`} />
                  <span className="text-[10px] mt-0.5">{nav.label}</span>
                </button>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
};
