enum EnumTimestampModel { createdAt, modifiedAt }

enum EnumUserDetails { id, createdAt, modifiedAt }

enum EnumAdminDetails { id, reportType, data, startDate, endDate }

enum EnumReport { id, isApproved, createdAt, modifiedAt }

enum EnumAccountSettings { id, loginAlerts, notifications, soundEffects, backgroundMusic }

enum EnumRoom { id, hostID, challengeIDs, name, password, capacity }

enum EnumScore { id, overallScore, runTime, timeElapsed, rank }

enum EnumLeaderboard { id, accountIDs, dateCreated }

enum EnumChallenge { id, name, description, difficulty, isShared, tags, dateCreated }

enum EnumFeedbackModel { id, title, message, createdAt }
