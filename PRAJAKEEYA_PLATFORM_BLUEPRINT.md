# JanaBala (ಜನಬಲ) - Digital Democracy Platform

**Author:** Yeshwanth C R (ysocrius)  
**Date:** May 2026  
**Version:** 3.0 - Phase-Based Development  
**Status:** Implementation-Ready

---

## Table of Contents

1. [Vision & Win-Win Summary](#1-vision--win-win-summary)
2. [Phase-Based Development Overview](#2-phase-based-development-overview)
3. [Phase 1: Foundation - Core Platform](#3-phase-1-foundation--core-platform)
4. [Phase 2: Intelligence - AI & RAG Engine](#4-phase-2-intelligence--ai--rag-engine)
5. [Phase 3: Trust - Blockchain Audit Layer](#5-phase-3-trust--blockchain-audit-layer)
6. [Phase 4: Autonomy - Agentic AI Systems](#6-phase-4-autonomy--agentic-ai-systems)
7. [Phase 5: Scale - Federation & DAO Governance](#7-phase-5-scale--federation--dao-governance)
8. [NammaKasa Comparison](#8-nammakasa-comparison)
9.  [Competitive Analysis: What to Borrow from Global Platforms](#9-competitive-analysis-what-to-borrow-from-global-platforms)
10. [Why Offline-first Flutter + Next.js?](#10-why-offline-first-flutter--nextjs)
11. [Tiered Authentication Model](#11-tiered-authentication-model)
12. [Deployment & Infrastructure](#12-deployment--infrastructure)
13. [Timeline & Milestones](#13-timeline--milestones)
14. [How to Pitch to UPP](#14-how-to-pitch-to-upp)
15. [Portfolio & Career Leverage](#15-portfolio--career-leverage)
16. [Security, Legal & Operational Readiness](#16-security-legal--operational-readiness)
17. [Cost Estimation (INR, 2026)](#17-cost-estimation-inr-2026)
18. [Sponsorship & Funding Sources](#18-sponsorship--funding-sources)
19. [Legal Entity & Funding Strategy](#19-legal-entity--funding-strategy)

---

## 1. Vision & Win-Win Summary

### What is Prajakeeya?

Prajakeeya = "Of the People" - Actor/Director Upendra Rao's political movement built on:
- **ART**: Accountability, Responsibility, Transparency
- **5-Point Program**: Selection -> Election -> Correction -> Rejection -> Promotion
- **Tech-Driven**: Digital polling, Right-to-Recall, citizen participation via mobile
- **Party**: Uttama Prajaakeeya Party (UPP), registered with EC, symbol = auto-rickshaw
- **App**: "The Real Prajakeeya" launched April 2026

### Why Build This?

**For UPP:**
- No Indian political party has a production-grade tech backbone
- Rural Karnataka (32,000 villages) has low connectivity - needs offline-first
- Transparent governance tools build voter trust
- Differentiator from BJP/Congress/JDS

**For You (Yeshwanth):**
- State-level civic-tech platform on your resume
- Direct relationship with UPP leadership
- Opens govtech/civic-tech career path
- Attracts grants (Omidyar Network, Mozilla Foundation, National Democratic Institute)
- Could become CTO of UPP's tech wing
- Open-source contribution with real-world impact

### UPP Stance on Blockchain & AI

Based on research (Deccan Herald April 2026, prajaakeeya.org):
- **Current Platform**: Basic issue reporting + opinion polls (no blockchain, no advanced AI)
- **Philosophy Alignment**: ART (Accountability, Responsibility, Transparency) aligns well with blockchain immutability promise
- **No Public Position**: UPP has not publicly endorsed or rejected blockchain/agentic AI
- **Opportunity**: First-mover advantage - no Indian political party has deployed blockchain for democratic processes

---

## 2. Phase-Based Development Overview

### Philosophy: Start Simple, Compound Complexity

Each phase builds on the previous. No phase requires the next. Ship value at every stage.

```
+-----------------------------------------------------------------------------+
|                     JANABALA PHASE PROGRESSION                              |
+-----------------------------------------------------------------------------+
|                                                                             |
|  PHASE 1: FOUNDATION (Weeks 1-4)                                            |
|  +-- Goal: Working app in citizens hands                                    |
|  +-- Tech: Flutter + FastAPI + PostgreSQL                                   |
|  +-- Features: Issue CRUD, offline-first, basic dashboard                  |
|  +-- Complexity: *----                                                      |
|                                                                             |
|  PHASE 2: INTELLIGENCE (Weeks 5-8)                                          |
|  +-- Goal: AI-powered insights & transparency                               |
|  +-- Tech: + LangGraph + pgvector + RAG pipeline                            |
|  +-- Features: Issue classification, budget RAG, scorecards                |
|  +-- Complexity: **---                                                      |
|                                                                             |
|  PHASE 3: TRUST (Weeks 9-12)                                                |
|  +-- Goal: Tamper-proof audit trails                                        |
|  +-- Tech: + Hyperledger/Polygon + Smart Contracts                          |
|  +-- Features: Immutable issue log, recall audit, vote receipts            |
|  +-- Complexity: ***--                                                      |
|                                                                             |
|  PHASE 4: AUTONOMY (Weeks 13-16)                                            |
|  +-- Goal: Self-improving, autonomous governance                            |
|  +-- Tech: + Agentic AI + Memory + Tool Use                                 |
|  +-- Features: Auto-grievance agent, policy analyst, predictive alerts     |
|  +-- Complexity: ****-                                                      |
|                                                                             |
|  PHASE 5: SCALE (Weeks 17-24)                                               |
|  +-- Goal: Multi-state federation, DAO governance                           |
|  +-- Tech: + Federation Protocol + DAO + Token Economics                    |
|  +-- Features: Cross-state sync, citizen tokens, quadratic voting          |
|  +-- Complexity: *****                                                      |
|                                                                             |
+-----------------------------------------------------------------------------+
```

### Phase Decision Matrix

| Phase | Can Skip? | Reversibility | User Value | Technical Debt |
|-------|-----------|---------------|------------|----------------|
| Phase 1 | No (MVP) | High | High | Low |
| Phase 2 | Yes | High | High | Medium |
| Phase 3 | Yes | Medium | Medium | Medium |
| Phase 4 | Yes | Low | Medium | High |
| Phase 5 | Yes | Low | Low | High |

### Technology Progression

| Layer | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 |
|-------|---------|---------|---------|---------|---------|
| Mobile | Flutter | Flutter | Flutter | Flutter | Flutter |
| Web | Next.js | Next.js | Next.js | Next.js | Next.js |
| API | FastAPI | FastAPI | FastAPI | FastAPI | FastAPI |
| DB | PostgreSQL | + pgvector | + pgvector | + pgvector | + pgvector |
| Cache | Redis | Redis | Redis | Redis | Redis |
| AI | None | LangGraph | LangGraph | Agentic AI | Agentic AI |
| Blockchain | None | None | Polygon | Polygon | Polygon |
| Queue | None | Celery | Celery | Celery | Celery |

---

## 3. Phase 1: Foundation - Core Platform

### 3.1 Goal

A working, production-grade civic issue reporting platform in citizens' hands within 4 weeks. Offline-first mobile app covering all 224 Karnataka assembly constituencies. No AI, no blockchain - just solid CRUD with offline sync.

### 3.2 Scope

| Feature | Phase 1 | Future |
|---------|---------|--------|
| Issue Reporting (Create, Read) | Yes | Update, Delete |
| Offline-first (SQLite local) | Yes | Conflict resolution with merge |
| OTP-based Authentication | Yes | Voter ID tier |
| Photo Upload | Yes | Video upload |
| Issue Categories (12+ types) | Yes | AI auto-classify |
| Basic Dashboard (Web) | Yes | Advanced analytics |
| Kannada Language Support | Yes | Full i18n |
| Push Notifications | Yes | Smart routing |
| Map View of Issues | Yes | Heat maps, trends |

### 3.3 Directory Structure

```
janabala_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── models/
│   │   ├── issue.dart
│   │   ├── user.dart
│   │   └── sync_metadata.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── sync_service.dart
│   │   ├── offline_queue.dart
│   │   └── local_db_service.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── issue_provider.dart
│   │   └── sync_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── otp_screen.dart
│   │   ├── home_screen.dart
│   │   ├── report_issue_screen.dart
│   │   ├── issue_detail_screen.dart
│   │   └── dashboard_screen.dart
│   └── widgets/
│       ├── issue_card.dart
│       ├── category_picker.dart
│       └── sync_status_badge.dart
├── pubspec.yaml
└── analysis_options.yaml
```

### 3.4 Database Schema

```sql
-- Constituencies (Karnataka has 224 assembly constituencies)
CREATE TABLE constituencies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    district VARCHAR(200),
    state VARCHAR(100) DEFAULT 'Karnataka',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Users
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone VARCHAR(15) UNIQUE NOT NULL,
    name VARCHAR(200),
    constituency_id UUID REFERENCES constituencies(id),
    role VARCHAR(50) DEFAULT 'citizen',
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- OTP sessions for auth
CREATE TABLE otp_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone VARCHAR(15) NOT NULL,
    otp VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Issues (civic problems reported by citizens)
CREATE TABLE issues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    constituency_id UUID REFERENCES constituencies(id),
    category VARCHAR(50) NOT NULL,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    photo_urls TEXT[],
    urgency VARCHAR(10) DEFAULT 'LOW',
    status VARCHAR(20) DEFAULT 'open',
    assigned_to UUID REFERENCES users(id),
    resolved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_issues_constituency ON issues(constituency_id);
CREATE INDEX idx_issues_status ON issues(status);
CREATE INDEX idx_issues_category ON issues(category);
CREATE INDEX idx_issues_created ON issues(created_at DESC);

-- Sync log for offline tracking
CREATE TABLE sync_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL,
    payload JSONB,
    synced_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sync_user ON sync_log(user_id);
CREATE INDEX idx_sync_status ON sync_log(synced_at);
```

### 3.5 API Endpoints (Phase 1)

```
AUTH
+-- POST   /api/v1/auth/send-otp           [Public]
+-- POST   /api/v1/auth/verify-otp          [Public]
+-- GET    /api/v1/auth/me                  [Auth Required]

ISSUES
+-- GET    /api/v1/issues                   [Public]
+-- GET    /api/v1/issues/:id              [Public]
+-- POST   /api/v1/issues                   [Auth Required]
+-- PUT    /api/v1/issues/:id              [Auth Required]
+-- DELETE /api/v1/issues/:id              [Admin]

SYNC
+-- POST   /api/v1/sync/push               [Auth Required]
+-- GET    /api/v1/sync/pull?since=<ts>    [Auth Required]

HEALTH
+-- GET    /api/v1/health                   [Public]
```

### 3.6 FastAPI Backend

```python
# services/api/app/main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import auth, issues, sync

app = FastAPI(title="JanaBala API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(issues.router, prefix="/api/v1/issues", tags=["issues"])
app.include_router(sync.router, prefix="/api/v1/sync", tags=["sync"])


@app.get("/api/v1/health")
async def health():
    return {"status": "healthy", "version": "1.0.0", "phase": "1"}
```

```python
# services/api/app/config.py

from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    APP_NAME: str = "JanaBala API"
    DATABASE_URL: str = "postgresql+asyncpg://janabala:password@localhost:5432/janabala"
    REDIS_URL: str = "redis://localhost:6379/0"
    SECRET_KEY: str = "change-me-in-production"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7
    CORS_ORIGINS: List[str] = ["*"]
    SMS_PROVIDER: str = "msg91"
    SMS_API_KEY: str = ""
    OTP_LENGTH: int = 6
    OTP_EXPIRE_SECONDS: int = 300
    AI_SERVICE_URL: str = "http://ai_service:8001"
    DATABASE_POOL_SIZE: int = 10
    DATABASE_MAX_OVERFLOW: int = 20

    class Config:
        env_file = ".env"


settings = Settings()
```

```python
# services/api/app/routers/issues.py

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel
from typing import Optional, List
from uuid import UUID, uuid4
from datetime import datetime

router = APIRouter()


class IssueCreate(BaseModel):
    category: str
    title: str
    description: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    photo_urls: Optional[List[str]] = None
    urgency: str = "LOW"


class IssueResponse(BaseModel):
    id: UUID
    category: str
    title: str
    description: Optional[str]
    status: str
    urgency: str
    created_at: datetime
    updated_at: datetime


@router.get("/", response_model=List[IssueResponse])
async def list_issues(
    constituency_id: Optional[UUID] = Query(None),
    category: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    limit: int = Query(50, le=100),
    offset: int = Query(0, ge=0),
):
    return []


@router.get("/{issue_id}", response_model=IssueResponse)
async def get_issue(issue_id: UUID):
    raise HTTPException(status_code=404, detail="Issue not found")


@router.post("/", response_model=IssueResponse, status_code=201)
async def create_issue(issue: IssueCreate):
    return IssueResponse(
        id=uuid4(),
        category=issue.category,
        title=issue.title,
        description=issue.description,
        status="open",
        urgency=issue.urgency,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )


@router.put("/{issue_id}", response_model=IssueResponse)
async def update_issue(issue_id: UUID, issue: IssueCreate):
    raise HTTPException(status_code=404, detail="Issue not found")
```

### 3.7 Flutter App Code

```yaml
# apps/flutter/pubspec.yaml

name: janabala_app
description: JanaBala - Digital Democracy Platform
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.9.0
  http: ^1.2.0
  connectivity_plus: ^6.0.0
  flutter_secure_storage: ^9.2.0
  provider: ^6.1.0
  geolocator: ^11.0.0
  image_picker: ^1.0.7
  intl: ^0.19.0
  cached_network_image: ^3.3.0
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

```dart
// apps/flutter/lib/models/issue.dart

import 'dart:convert';

class Issue {
  final String id;
  final String userId;
  final String constituencyId;
  final String category;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final List<String>? photoUrls;
  final String urgency;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  Issue({
    required this.id,
    required this.userId,
    required this.constituencyId,
    required this.category,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.photoUrls,
    this.urgency = 'LOW',
    this.status = 'open',
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'constituency_id': constituencyId,
    'category': category,
    'title': title,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'photo_urls': photoUrls != null ? jsonEncode(photoUrls) : null,
    'urgency': urgency,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'is_synced': isSynced ? 1 : 0,
  };

  factory Issue.fromMap(Map<String, dynamic> map) => Issue(
    id: map['id'],
    userId: map['user_id'],
    constituencyId: map['constituency_id'],
    category: map['category'],
    title: map['title'],
    description: map['description'],
    latitude: map['latitude'],
    longitude: map['longitude'],
    photoUrls: map['photo_urls'] != null
        ? (map['photo_urls'] as String).startsWith('[')
            ? (jsonDecode(map['photo_urls'] as String) as List).cast<String>()
            : (map['photo_urls'] as String).split(',')
        : null,
    urgency: map['urgency'],
    status: map['status'],
    createdAt: DateTime.parse(map['created_at']),
    updatedAt: DateTime.parse(map['updated_at']),
    isSynced: map['is_synced'] == 1,
  );

  Map<String, dynamic> toJson() => {
    'category': category,
    'title': title,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'photo_urls': photoUrls,
    'urgency': urgency,
  };
}
```

```dart
// apps/flutter/lib/services/offline_queue.dart

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class OfflineQueue {
  static Database? _db;
  static const int _dbVersion = 2;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'janabala_offline.db');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pending_operations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            operation_type TEXT NOT NULL,
            entity_type TEXT NOT NULL,
            entity_id TEXT NOT NULL,
            payload TEXT NOT NULL,
            idempotency_key TEXT,
            created_at TEXT NOT NULL,
            retry_count INTEGER DEFAULT 0,
            failed_permanently INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE local_issues (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            constituency_id TEXT NOT NULL,
            category TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            latitude REAL,
            longitude REAL,
            photo_urls TEXT,
            urgency TEXT DEFAULT 'LOW',
            status TEXT DEFAULT 'open',
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            is_synced INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE sync_metadata (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE pending_operations ADD COLUMN idempotency_key TEXT');
          await db.execute('ALTER TABLE pending_operations ADD COLUMN failed_permanently INTEGER DEFAULT 0');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sync_metadata (
              key TEXT PRIMARY KEY,
              value TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  static Future<void> enqueueOperation({
    required String operationType,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    final db = await database;
    await db.insert('pending_operations', {
      'operation_type': operationType,
      'entity_type': entityType,
      'entity_id': entityId,
      'payload': jsonEncode(payload),
      'idempotency_key': idempotencyKey,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getPendingOperations() async {
    final db = await database;
    return await db.query(
      'pending_operations',
      where: 'failed_permanently = 0',
      orderBy: 'created_at ASC',
      limit: 50,
    );
  }

  static Future<void> removeOperation(int id) async {
    final db = await database;
    await db.delete('pending_operations', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> incrementRetry(int id) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE pending_operations SET retry_count = retry_count + 1 WHERE id = ?',
      [id],
    );
  }

  static Future<void> markFailedPermanently(int id) async {
    final db = await database;
    await db.update(
      'pending_operations',
      {'failed_permanently': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> saveIssueLocally(Map<String, dynamic> issue) async {
    final db = await database;
    final copy = Map<String, dynamic>.from(issue);
    if (copy['photo_urls'] is List) {
      copy['photo_urls'] = jsonEncode(copy['photo_urls']);
    }
    await db.insert(
      'local_issues',
      copy,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getUnsyncedIssues() async {
    final db = await database;
    return await db.query(
      'local_issues',
      where: 'is_synced = 0',
      orderBy: 'created_at DESC',
    );
  }

  static Future<void> markSynced(String id) async {
    final db = await database;
    await db.update(
      'local_issues',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> setLastSyncTimestamp(String timestamp) async {
    final db = await database;
    await db.insert(
      'sync_metadata',
      {'key': 'last_sync', 'value': timestamp},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> getLastSyncTimestamp() async {
    final db = await database;
    final result = await db.query(
      'sync_metadata',
      where: 'key = ?',
      whereArgs: ['last_sync'],
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }
}
```

```dart
// apps/flutter/lib/services/sync_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'offline_queue.dart';

class SyncService {
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;
  Timer? _periodicTimer;
  static const Duration _requestTimeout = Duration(seconds: 30);
  static const int _maxRetriesPerOp = 5;

  SyncService({required this.baseUrl});

  void startPeriodicSync() {
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => syncIfOnline(),
    );
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (_) => syncIfOnline(),
    );
  }

  void stopPeriodicSync() {
    _periodicTimer?.cancel();
    _connectivitySubscription?.cancel();
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> syncIfOnline() async {
    if (_isSyncing) return;
    if (!await isOnline()) return;

    _isSyncing = true;
    try {
      await _pushPendingOperations();
      await _pullRemoteUpdates();
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _pushPendingOperations() async {
    final operations = await OfflineQueue.getPendingOperations();
    for (final op in operations) {
      final retryCount = op['retry_count'] as int? ?? 0;
      if (retryCount >= _maxRetriesPerOp) {
        await OfflineQueue.markFailedPermanently(op['id'] as int);
        continue;
      }
      try {
        final response = await _executeOperation(op).timeout(_requestTimeout);
        if (response.statusCode == 200 || response.statusCode == 201) {
          await OfflineQueue.removeOperation(op['id'] as int);
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          await OfflineQueue.removeOperation(op['id'] as int);
        }
      } catch (_) {
        await OfflineQueue.incrementRetry(op['id'] as int);
      }
    }
  }

  Future<http.Response> _executeOperation(Map<String, dynamic> op) async {
    final payload = jsonDecode(op['payload'] as String);
    final headers = await _authHeaders();

    switch (op['operation_type']) {
      case 'create_issue':
        return await http.post(
          Uri.parse('$baseUrl/issues'),
          headers: headers,
          body: jsonEncode(payload),
        );
      case 'update_issue':
        return await http.put(
          Uri.parse('$baseUrl/issues/${op['entity_id']}'),
          headers: headers,
          body: jsonEncode(payload),
        );
      default:
        throw Exception('Unknown operation type');
    }
  }

  Future<void> _pullRemoteUpdates() async {
    final lastSync = await _getLastSyncTime();
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/sync/pull?since=$lastSync'),
      headers: headers,
    ).timeout(_requestTimeout);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      for (final item in data) {
        await OfflineQueue.saveIssueLocally(item as Map<String, dynamic>);
      }
      await OfflineQueue.setLastSyncTimestamp(DateTime.now().toIso8601String());
    }
  }

  Future<String> _getLastSyncTime() async {
    final stored = await OfflineQueue.getLastSyncTimestamp();
    return stored ?? DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();
  }
}
```

---

## 4. Phase 2: Intelligence - AI & RAG Engine

### 4.1 Goal

Add AI-powered insights: automatic issue classification, urgency detection, Kannada translation, and a RAG (Retrieval-Augmented Generation) pipeline for government budget transparency. Introduce candidate scorecards and citizen polling.

### 4.2 Scope

| Feature | Phase 1 | Phase 2 |
|---------|---------|---------|
| Issue Classification | Manual category selection | AI auto-classify + urgency |
| Budget Data | None | PDF ingestion, RAG Q&A |
| Candidate Scorecards | None | Attendance, resolution %, promises |
| Polls | None | Create, vote, results |
| Kannada Translation | Static UI | AI translation for descriptions |
| Async Processing | None | Celery workers |

### 4.3 AI Service Directory Structure

```
services/ai/
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── config.py
│   ├── classification_graph.py
│   ├── translation_service.py
│   └── rag_pipeline.py
├── requirements.txt
└── Dockerfile
```

### 4.4 LangGraph Classification Pipeline

```python
# services/ai/app/classification_graph.py

from langgraph.graph import StateGraph, END
from typing import TypedDict, Optional, List
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel, Field


class ClassificationOutput(BaseModel):
    category: str = Field(description="Issue category from: ROADS, WATER, ELECTRICITY, WASTE, HEALTHCARE, EDUCATION, TRANSPORT, STREETLIGHT, DRAINAGE, PARK, NOISE, OTHER")
    urgency: str = Field(description="Urgency level: LOW, MEDIUM, HIGH, CRITICAL")
    confidence: float = Field(description="Confidence score 0.0-1.0", ge=0, le=1)
    needs_human_review: bool = Field(description="Whether this needs manual review")
    reasoning: str = Field(description="Brief reasoning for the classification")


class ClassificationState(TypedDict):
    issue_id: str
    issue_title: str
    issue_description: str
    category: Optional[str]
    urgency: Optional[str]
    confidence: Optional[float]
    needs_human_review: bool
    classification: Optional[ClassificationOutput]
    error: Optional[str]


class ClassificationGraph:
    CATEGORIES = [
        "ROADS", "WATER", "ELECTRICITY", "WASTE",
        "HEALTHCARE", "EDUCATION", "TRANSPORT",
        "STREETLIGHT", "DRAINAGE", "PARK", "NOISE", "OTHER"
    ]

    def __init__(self):
        self.llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
        self.structured_llm = self.llm.with_structured_output(ClassificationOutput)
        self.graph = self._build_graph()

    def _build_graph(self):
        builder = StateGraph(ClassificationState)

        builder.add_node("classify", self._classify_node)
        builder.add_node("validate", self._validate_node)
        builder.add_node("fallback", self._fallback_node)

        builder.set_entry_point("classify")
        builder.add_conditional_edges(
            "classify",
            self._route_after_classify,
            {"validate": "validate", "fallback": "fallback"}
        )
        builder.add_conditional_edges(
            "validate",
            self._route_after_validate,
            {END: END, "fallback": "fallback"}
        )
        builder.add_edge("fallback", END)

        return builder.compile()

    async def _classify_node(self, state: ClassificationState) -> ClassificationState:
        try:
            text = f"Title: {state['issue_title']}\nDescription: {state['issue_description']}"
            prompt = ChatPromptTemplate.from_messages([
                ("system", """You are a civic issue classifier for Karnataka, India.
Classify the issue into exactly one category and determine urgency.
Categories: ROADS, WATER, ELECTRICITY, WASTE, HEALTHCARE, EDUCATION, TRANSPORT, STREETLIGHT, DRAINAGE, PARK, NOISE, OTHER

Urgency guidelines:
- CRITICAL: Life-threatening, structural collapse, major accident, electrical fire
- HIGH: Large pothole on main road, major water leak, power outage >6hrs
- MEDIUM: Minor road damage, streetlight out, garbage not collected
- LOW: Minor inconvenience, suggestion, general inquiry"""),
                ("user", text),
            ])
            chain = prompt | self.structured_llm
            result = await chain.ainvoke({})
            state["classification"] = result
            state["category"] = result.category
            state["urgency"] = result.urgency
            state["confidence"] = result.confidence
            state["needs_human_review"] = result.needs_human_review
            state["error"] = None
        except Exception as e:
            state["error"] = str(e)
            state["needs_human_review"] = True
        return state

    def _route_after_classify(self, state: ClassificationState) -> str:
        if state.get("error") or state.get("classification") is None:
            return "fallback"
        return "validate"

    def _validate_node(self, state: ClassificationState) -> ClassificationState:
        cls = state["classification"]
        if cls and cls.category not in self.CATEGORIES:
            cls.category = "OTHER"
            cls.confidence *= 0.5
            cls.needs_human_review = True
            state["classification"] = cls
        if cls and cls.confidence < 0.4:
            cls.needs_human_review = True
            state["classification"] = cls
        return state

    def _route_after_validate(self, state: ClassificationState) -> str:
        if state["classification"] and state["classification"].needs_human_review:
            return "fallback"
        return END

    def _fallback_node(self, state: ClassificationState) -> ClassificationState:
        state["needs_human_review"] = True
        if state.get("classification") is None:
            state["classification"] = ClassificationOutput(
                category="OTHER",
                urgency="LOW",
                confidence=0.0,
                needs_human_review=True,
                reasoning="Fallback: AI unavailable, queued for human review"
            )
        return state

    async def classify(self, issue_id: str, title: str, description: str) -> ClassificationState:
        initial = ClassificationState(
            issue_id=issue_id,
            issue_title=title,
            issue_description=description,
            category=None,
            urgency=None,
            confidence=None,
            needs_human_review=False,
            classification=None,
            error=None,
        )
        return await self.graph.ainvoke(initial)
```
### 4.5 Database Schema Additions (Phase 2)

```sql
-- Candidates table
CREATE TABLE candidates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    party VARCHAR(100),
    constituency_id UUID REFERENCES constituencies(id),
    position VARCHAR(50),
    is_incumbent BOOLEAN DEFAULT FALSE,
    photo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Budget documents (uploaded PDFs)
CREATE TABLE budget_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(500) NOT NULL,
    year VARCHAR(10) NOT NULL,
    document_type VARCHAR(50),
    file_url TEXT,
    status VARCHAR(20) DEFAULT 'processing',
    page_count INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Budget items (extracted from PDF)
CREATE TABLE budget_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID REFERENCES budget_documents(id),
    department VARCHAR(200),
    head VARCHAR(500),
    description TEXT,
    allocated DECIMAL(20, 2),
    spent DECIMAL(20, 2),
    financial_year VARCHAR(10),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_budget_doc ON budget_items(document_id);
CREATE INDEX idx_budget_dept ON budget_items(department);

-- Budget embeddings for RAG
CREATE TABLE budget_embeddings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID REFERENCES budget_documents(id),
    chunk_text TEXT NOT NULL,
    embedding vector(1536),
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_budget_embed ON budget_embeddings
    USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- Polls
CREATE TABLE polls (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(500) NOT NULL,
    description TEXT,
    constituency_id UUID REFERENCES constituencies(id),
    options JSONB NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Poll votes
CREATE TABLE poll_votes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    poll_id UUID REFERENCES polls(id),
    user_id UUID REFERENCES users(id),
    option_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(poll_id, user_id)
);

CREATE INDEX idx_poll_votes_poll ON poll_votes(poll_id);

-- Candidate scorecards
CREATE TABLE candidate_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    candidate_id UUID REFERENCES candidates(id),
    attendance_score DECIMAL(5, 2),
    resolution_score DECIMAL(5, 2),
    promise_score DECIMAL(5, 2),
    overall_score DECIMAL(5, 2),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_scores_candidate ON candidate_scores(candidate_id);
```

### 4.6 API Endpoints Added (Phase 2)

```
AI & CLASSIFICATION
+-- POST   /api/v1/ai/classify              [Auth Required]
+-- GET    /api/v1/ai/summary/:issueId      [Public]

BUDGET RAG
+-- POST   /api/v1/budget/upload            [Admin]
+-- GET    /api/v1/budget/query             [Public]
+-- GET    /api/v1/budget/documents         [Public]
+-- GET    /api/v1/budget/documents/:id     [Public]

SCORECARDS
+-- GET    /api/v1/scorecards/:constituencyId  [Public]
+-- GET    /api/v1/candidates/:id             [Public]

POLLS
+-- POST   /api/v1/polls                    [Admin]
+-- GET    /api/v1/polls                    [Public]
+-- GET    /api/v1/polls/:id                [Public]
+-- POST   /api/v1/polls/:id/vote           [Auth Required]
+-- GET    /api/v1/polls/:id/results        [Public]
```

### 4.7 Celery Tasks for Async AI Processing

```python
# services/api/app/workers/celery_app.py

from celery import Celery
from app.config import settings

celery_app = Celery(
    "janabala",
    broker=settings.REDIS_URL,
    backend=settings.REDIS_URL,
)

celery_app.conf.task_routes = {
    "workers.tasks.*": {"queue": "ai_tasks"},
}
```

```python
# services/api/app/workers/tasks.py

import httpx
from celery import shared_task
from app.config import settings


@shared_task(bind=True, max_retries=3, default_retry_delay=60)
def classify_issue(self, issue_id: str, title: str, description: str):
    """Send issue to AI service for classification"""
    try:
        with httpx.Client(timeout=30.0) as client:
            response = client.post(
                f"{settings.AI_SERVICE_URL}/api/v1/ai/classify",
                json={
                    "issue_id": issue_id,
                    "title": title,
                    "description": description,
                },
            )
            response.raise_for_status()
            return response.json()
    except Exception as exc:
        raise self.retry(exc=exc)


@shared_task(bind=True, max_retries=2, default_retry_delay=300)
def process_budget_document(self, document_id: str):
    """Extract and embed budget PDF content"""
    try:
        with httpx.Client(timeout=120.0) as client:
            response = client.post(
                f"{settings.AI_SERVICE_URL}/api/v1/budget/process",
                json={"document_id": document_id},
            )
            response.raise_for_status()
            return response.json()
    except Exception as exc:
        raise self.retry(exc=exc)


@shared_task
def translate_issue_description(issue_id: str, text: str, target_lang: str = "kn"):
    """Translate issue description to/from Kannada"""
    with httpx.Client(timeout=30.0) as client:
        response = client.post(
            f"{settings.AI_SERVICE_URL}/api/v1/translate",
            json={
                "text": text,
                "target_language": target_lang,
            },
        )
        return response.json()
```

### 4.8 RAG Pipeline for Budget Transparency

```python
# services/ai/app/rag_pipeline.py

import os
from typing import List, Optional
from pydantic import BaseModel
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain_postgres.vectorstores import PGVector
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA


class BudgetRAGPipeline:
    def __init__(self):
        self.embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
        self.llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
        self.connection_string = os.getenv("DATABASE_URL")
        self.collection_name = "budget_embeddings"
        self.vectorstore = self._get_vectorstore()

    def _get_vectorstore(self):
        return PGVector(
            embeddings=self.embeddings,
            collection_name=self.collection_name,
            connection=self.connection_string,
            use_jsonb=True,
        )

    def process_document(self, file_path: str, document_id: str, metadata: dict = None):
        """Ingest a budget PDF into the vector store"""
        import fitz

        doc = fitz.open(file_path)
        text_chunks = []

        for page_num in range(len(doc)):
            page = doc[page_num]
            text = page.get_text()
            if text.strip():
                text_chunks.append({
                    "text": text,
                    "page": page_num + 1,
                    "document_id": document_id,
                })

        splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,
            chunk_overlap=200,
            separators=["\n\n", "\n", ".", " "],
        )

        docs = []
        for chunk in text_chunks:
            splits = splitter.split_text(chunk["text"])
            for i, split in enumerate(splits):
                docs.append({
                    "text": split,
                    "metadata": {
                        "document_id": document_id,
                        "page": chunk["page"],
                        "chunk_index": i,
                        **(metadata or {}),
                    }
                })

        texts = [d["text"] for d in docs]
        metadatas = [d["metadata"] for d in docs]
        self.vectorstore.add_texts(texts=texts, metadatas=metadatas)

        return len(docs)

    def query(self, question: str, document_id: Optional[str] = None, top_k: int = 5):
        """Query the budget with a natural language question"""
        filter_dict = {}
        if document_id:
            filter_dict["document_id"] = document_id

        retriever = self.vectorstore.as_retriever(
            search_type="similarity",
            search_kwargs={"k": top_k, "filter": filter_dict},
        )

        qa_chain = RetrievalQA.from_chain_type(
            llm=self.llm,
            chain_type="stuff",
            retriever=retriever,
            return_source_documents=True,
        )

        result = qa_chain.invoke({
            "query": f"""You are a budget analyst for Karnataka state government.
Answer the question based on the provided budget document excerpts.
If the answer cannot be found in the excerpts, say so clearly.
Provide specific numbers and departments where available.

Question: {question}"""
        })

        return {
            "answer": result["result"],
            "sources": [
                {
                    "document_id": doc.metadata.get("document_id"),
                    "page": doc.metadata.get("page"),
                    "excerpt": doc.page_content[:200],
                }
                for doc in result["source_documents"]
            ],
        }
```

---

## 5. Phase 3: Trust - Blockchain Audit Layer

### 5.1 Goal

Add tamper-proof audit trails for issues, votes, and candidate scorecards using blockchain.

### 5.2 Why Blockchain?

| Use Case | Problem Solved | Blockchain Value |
|----------|----------------|------------------|
| Issue Audit Trail | Issues can be deleted/modified by admins | Immutable proof of citizen reports |
| Vote Integrity | Poll results can be manipulated | Verifiable, tamper-proof vote records |
| Scorecard Integrity | Scores can be altered | Transparent performance history |
| Right-to-Recall | Trigger can be suppressed | Automated, trustless recall process |

### 5.3 Blockchain Choice: Polygon vs Hyperledger

| Criteria | Polygon (L2) | Hyperledger Fabric |
|----------|--------------|-------------------|
| Type | Public, permissionless | Private, permissioned |
| Cost | Low gas fees (~$0.01/tx) | No gas, but infrastructure cost |
| Speed | ~2s finality | <1s finality |
| Transparency | Full public audit | Consortium-only access |
| Setup Complexity | Medium (deploy contracts) | High (setup network) |
| Best For | Public accountability | Internal party governance |

**Recommendation**: Start with **Polygon** for public accountability. Migrate to private chain if scale demands.

### 5.4 Architecture (Phase 3)

```
+-----------------------------------------------------------------+
|                    PHASE 3 ARCHITECTURE                          |
+-----------------------------------------------------------------+
|                                                                  |
|  +--------------+  +--------------+  +--------------+           |
|  |  Flutter App  |  |   Next.js    |  |  Admin Panel |           |
|  +------+-------+  +------+-------+  +------+-------+           |
|         |                 |                 |                    |
|         +-----------------+-----------------+                    |
|                           |                                      |
|                  +--------+--------+                             |
|                  |   FastAPI API   |                             |
|                  +--------+--------+                             |
|                           |                                      |
|         +-----------------+-----------------+                    |
|         |                 |                 |                    |
|  +------v------+   +------v------+   +------v------+            |
|  | PostgreSQL  |   | AI Service  |   |  Blockchain |            |
|  | + pgvector  |   | (LangGraph) |   |   Service   |            |
|  +-------------+   +-------------+   +-------------+            |
|                                              |                   |
|                                     +--------v--------+          |
|                                     | Polygon Network |          |
|                                     | (Smart Contract)|          |
|                                     +-----------------+          |
|                                                                  |
+-----------------------------------------------------------------+
```

### 5.5 Smart Contract Design

```solidity
// contracts/JanaBalaAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract JanaBalaAudit {
    
    struct IssueRecord {
        bytes32 issueId;
        address reporter;
        uint256 timestamp;
        string category;
        string ipfsHash;
        uint8 urgency;
        bool resolved;
    }
    
    struct VoteRecord {
        bytes32 pollId;
        address voter;
        uint256 timestamp;
        bytes32 optionHash;
    }
    
    struct ScoreRecord {
        bytes32 candidateId;
        uint256 period;
        uint8 overallScore;
        bool recallTriggered;
        uint256 timestamp;
    }
    
    mapping(bytes32 => IssueRecord) public issues;
    mapping(bytes32 => VoteRecord[]) public pollVotes;
    mapping(bytes32 => mapping(address => bool)) public hasVoted;
    mapping(bytes32 => ScoreRecord[]) public candidateScores;
    
    event IssueLogged(bytes32 indexed issueId, address indexed reporter, uint256 timestamp);
    event VoteCast(bytes32 indexed pollId, address indexed voter, uint256 timestamp);
    event ScoreUpdated(bytes32 indexed candidateId, uint8 score, bool recallTriggered);
    
    address public admin;
    address public apiOracle;
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }
    
    modifier onlyOracle() {
        require(msg.sender == apiOracle, "Only oracle");
        _;
    }
    
    constructor() {
        admin = msg.sender;
    }
    
    function setOracle(address _oracle) external onlyAdmin {
        apiOracle = _oracle;
    }
    
    function logIssue(
        bytes32 _issueId,
        address _reporter,
        string calldata _category,
        string calldata _ipfsHash,
        uint8 _urgency
    ) external onlyOracle {
        issues[_issueId] = IssueRecord({
            issueId: _issueId,
            reporter: _reporter,
            timestamp: block.timestamp,
            category: _category,
            ipfsHash: _ipfsHash,
            urgency: _urgency,
            resolved: false
        });
        
        emit IssueLogged(_issueId, _reporter, block.timestamp);
    }
    
    function castVote(
        bytes32 _pollId,
        bytes32 _optionHash
    ) external {
        require(!hasVoted[_pollId][msg.sender], "Already voted");
        hasVoted[_pollId][msg.sender] = true;
        
        pollVotes[_pollId].push(VoteRecord({
            pollId: _pollId,
            voter: msg.sender,
            timestamp: block.timestamp,
            optionHash: _optionHash
        }));
        
        emit VoteCast(_pollId, msg.sender, block.timestamp);
    }
    
    function updateScore(
        bytes32 _candidateId,
        uint256 _period,
        uint8 _overallScore,
        bool _recallTriggered
    ) external onlyOracle {
        candidateScores[_candidateId].push(ScoreRecord({
            candidateId: _candidateId,
            period: _period,
            overallScore: _overallScore,
            recallTriggered: _recallTriggered,
            timestamp: block.timestamp
        }));
        
        emit ScoreUpdated(_candidateId, _overallScore, _recallTriggered);
    }
    
    function resolveIssue(bytes32 _issueId) external onlyOracle {
        issues[_issueId].resolved = true;
    }
    
    function getIssue(bytes32 _issueId) external view returns (IssueRecord memory) {
        return issues[_issueId];
    }
    
    function getVoteCount(bytes32 _pollId) external view returns (uint256) {
        return pollVotes[_pollId].length;
    }
    
    function getScoreHistory(bytes32 _candidateId) external view returns (ScoreRecord[] memory) {
        return candidateScores[_candidateId];
    }
}
```

### 5.6 Blockchain Service (Python)

```python
# services/blockchain/app/main.py

import asyncio
import json
import os
from typing import Optional
from concurrent.futures import ThreadPoolExecutor

from web3 import Web3
from eth_account import Account
from pydantic import BaseModel

class BlockchainService:
    def __init__(self):
        self.w3 = Web3(Web3.HTTPProvider(os.getenv("POLYGON_RPC_URL")))
        self.contract_address = os.getenv("CONTRACT_ADDRESS")
        # Private key stored in Azure Key Vault / AWS KMS in production
        self.private_key = os.getenv("ORACLE_PRIVATE_KEY")
        self.account = Account.from_key(self.private_key)
        self.executor = ThreadPoolExecutor(max_workers=4)
        
        with open("contracts/JanaBalaAudit.json") as f:
            self.contract_abi = json.load(f)  # parsed JSON, not raw string
        
        self.contract = self.w3.eth.contract(
            address=self.contract_address,
            abi=self.contract_abi
        )
    
    async def _run_sync(self, fn, *args, **kwargs):
        """Run synchronous web3.py calls in thread pool to avoid blocking event loop"""
        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(self.executor, lambda: fn(*args, **kwargs))
    
    async def log_issue(
        self,
        issue_id: str,
        reporter_address: str,
        category: str,
        ipfs_hash: str,
        urgency: int
    ) -> str:
        def _do():
            tx = self.contract.functions.logIssue(
                Web3.keccak(text=issue_id),
                reporter_address,
                category,
                ipfs_hash,
                urgency
            ).build_transaction({
                "from": self.account.address,
                "nonce": self.w3.eth.get_transaction_count(self.account.address),
                "gas": 200000,
                "gasPrice": self.w3.eth.gas_price
            })
            signed = self.w3.eth.account.sign_transaction(tx, self.private_key)
            return self.w3.eth.send_raw_transaction(signed.rawTransaction).hex()
        return await self._run_sync(_do)
    
    async def cast_vote(self, poll_id: str, option_id: str) -> str:
        def _do():
            option_hash = Web3.keccak(text=option_id)
            tx = self.contract.functions.castVote(
                Web3.keccak(text=poll_id),
                option_hash
            ).build_transaction({
                "from": self.account.address,
                "nonce": self.w3.eth.get_transaction_count(self.account.address),
                "gas": 100000,
                "gasPrice": self.w3.eth.gas_price
            })
            signed = self.w3.eth.account.sign_transaction(tx, self.private_key)
            return self.w3.eth.send_raw_transaction(signed.rawTransaction).hex()
        return await self._run_sync(_do)
    
    async def update_score(
        self,
        candidate_id: str,
        period: int,
        score: int,
        recall_triggered: bool
    ) -> str:
        def _do():
            tx = self.contract.functions.updateScore(
                Web3.keccak(text=candidate_id),
                period,
                score,
                recall_triggered
            ).build_transaction({
                "from": self.account.address,
                "nonce": self.w3.eth.get_transaction_count(self.account.address),
                "gas": 150000,
                "gasPrice": self.w3.eth.gas_price
            })
            signed = self.w3.eth.account.sign_transaction(tx, self.private_key)
            return self.w3.eth.send_raw_transaction(signed.rawTransaction).hex()
        return await self._run_sync(_do)
    
    async def verify_issue(self, issue_id: str) -> dict:
        def _do():
            issue = self.contract.functions.getIssue(
                Web3.keccak(text=issue_id)
            ).call()
            return {
                "exists": issue[0] != b'\x00' * 32,
                "timestamp": issue[2],
                "category": issue[3],
                "resolved": issue[5]
            }
        return await self._run_sync(_do)
```

### 5.7 Database Schema Additions (Phase 3)

```sql
-- Blockchain transaction log
CREATE TABLE blockchain_tx (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    tx_hash VARCHAR(66) NOT NULL,
    block_number BIGINT,
    confirmed BOOLEAN DEFAULT FALSE,
    gas_used BIGINT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_bc_tx_entity ON blockchain_tx(entity_type, entity_id);
CREATE INDEX idx_bc_tx_hash ON blockchain_tx(tx_hash);

-- Wallet addresses for users
ALTER TABLE users ADD COLUMN wallet_address VARCHAR(42);

-- Vote receipts
CREATE TABLE vote_receipts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    poll_id UUID REFERENCES polls(id),
    user_id UUID REFERENCES users(id),
    option_id VARCHAR(50) NOT NULL,
    tx_hash VARCHAR(66) NOT NULL,
    receipt_code VARCHAR(20) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 5.8 API Endpoints Added (Phase 3)

```
BLOCKCHAIN
+-- GET    /api/v1/blockchain/verify/:issueId     [Public]
+-- GET    /api/v1/blockchain/receipt/:code       [Public]
+-- GET    /api/v1/blockchain/score/:candidateId  [Public]
+-- GET    /api/v1/blockchain/audit               [Public]
```

### 5.9 Cost Estimate (Polygon)

| Operation | Gas Used | Gas Price | Cost (MATIC) | Cost (USD @ $0.50) |
|-----------|----------|-----------|--------------|-------------------|
| Log Issue | ~80,000 | 30 gwei | 0.0024 | $0.0012 |
| Cast Vote | ~50,000 | 30 gwei | 0.0015 | $0.0008 |
| Update Score | ~60,000 | 30 gwei | 0.0018 | $0.0009 |

**Monthly estimate** (1000 issues, 5000 votes, 50 scores): ~$5/month

---

## 6. Phase 4: Autonomy - Agentic AI Systems

### 6.1 Goal

Transform from reactive AI (classification) to proactive, autonomous agents that reason, plan, and act. Agents maintain memory, use tools, and self-improve from feedback.

### 6.2 Traditional AI vs Agentic AI

| Dimension | Phase 2 AI | Phase 4 Agentic AI |
|-----------|------------|-------------------|
| Task scope | Single task (classify) | Multi-step reasoning chains |
| Memory | Stateless | Persistent vector memory |
| Tool use | None | DB queries, API calls, notifications |
| Behavior | Reactive | Proactive |
| Learning | None | Self-improving from feedback |
| Autonomy | Supervised | Semi-autonomous |

### 6.3 Agent Roster

```
+-----------------------------------------------------------------------------+
|                     JANABALA AGENT ECOSYSTEM                                |
+-----------------------------------------------------------------------------+
|                                                                             |
|  GRIEVANCE AGENT                                                            |
|  Purpose: Watches issues, drafts responses, tracks resolution               |
|  Tools: DB read/write, notification API, blockchain logger                  |
|  Memory: Past resolutions, citizen preferences                              |
|  Trigger: New issue submitted                                               |
|                                                                             |
|  BUDGET ANALYST AGENT                                                       |
|  Purpose: Monitor budget anomalies, compare promised vs actual              |
|  Tools: PDF reader, DB query, email/push notifications                      |
|  Memory: Previous budget cycles, known anomaly patterns                     |
|  Trigger: New budget doc uploaded OR weekly schedule                        |
|                                                                             |
|  POLICY ANALYST AGENT                                                       |
|  Purpose: Read gazettes, summarize in Kannada, flag impact                  |
|  Tools: Web scraper, translator, constituency DB                            |
|  Memory: Past policy impacts, constituency profile                          |
|  Trigger: Daily gazette scrape                                              |
|                                                                             |
|  PREDICTIVE AGENT                                                           |
|  Purpose: Pattern analysis to predict problems before crisis                |
|  Tools: Analytics DB, time-series analysis, alert system                   |
|  Memory: Historical issue patterns per constituency                         |
|  Trigger: Daily scheduled run                                               |
|                                                                             |
|  CITIZEN ASSISTANT AGENT                                                    |
|  Purpose: Personal guide for citizens, answers in Kannada                   |
|  Tools: Knowledge base, issue API, government portal scraper                |
|  Memory: Per-user conversation history, preferences                         |
|  Trigger: Citizen sends message                                             |
|                                                                             |
+-----------------------------------------------------------------------------+
```
### 6.4 Architecture (Phase 4)

```
+-----------------------------------------------------------------+
|                    PHASE 4 ARCHITECTURE                          |
+-----------------------------------------------------------------+
|                                                                  |
|  +--------------+  +--------------+  +--------------+           |
|  |  Flutter App  |  |   Next.js    |  |  Admin Panel |           |
|  +------+-------+  +------+-------+  +------+-------+           |
|         |                 |                 |                    |
|         +-----------------+-----------------+                    |
|                           |                                      |
|                  +--------+--------+                             |
|                  |   FastAPI API   |                             |
|                  +--------+--------+                             |
|                           |                                      |
|    +----------------------+----------------------+               |
|    |                      |                      |               |
| +--v--------+    +--------v-------+    +---------v------+        |
| | PostgreSQL |    |  Agent Runtime |    |  Blockchain    |        |
| | + pgvector |    | (LangGraph)    |    |   Service      |        |
| +------------+    +--------+-------+    +----------------+        |
|                            |                                      |
|               +------------+------------+                         |
|               |            |            |                         |
|        +------v--+  +------v--+  +------v--+                     |
|        |Grievance|  | Budget  |  |Predictive|                    |
|        |  Agent  |  |  Agent  |  |  Agent  |                    |
|        +---------+  +---------+  +---------+                     |
|                                                                  |
+-----------------------------------------------------------------+
```

### 6.5 Grievance Agent Implementation

```python
# services/agents/app/grievance_agent.py

from langgraph.graph import StateGraph, END
from langgraph.checkpoint.memory import MemorySaver
from langchain_openai import ChatOpenAI
from langchain_core.tools import tool
from typing import TypedDict, List, Optional, Annotated
import operator

class AgentState(TypedDict):
    issue_id: str
    description: str
    messages: Annotated[List, operator.add]
    actions_taken: List[str]
    severity: str
    escalated: bool
    resolution: Optional[str]

@tool
async def fetch_issue_history(constituency_id: str, category: str) -> str:
    """Fetch historical issues of same type in constituency"""
    return "5 similar WATER issues in last 30 days, avg resolution: 3 days"

@tool
async def notify_official(issue_id: str, urgency: str) -> str:
    """Send push notification to assigned official"""
    return f"Notified official for issue {issue_id}"

@tool
async def log_to_blockchain(issue_id: str, action: str) -> str:
    """Log action to blockchain for audit"""
    return f"Logged to blockchain: tx_hash=0x..."

@tool
async def draft_citizen_response(description: str, status: str, language: str) -> str:
    """Draft a response message for the citizen"""
    return f"Your issue has been received and assigned. Status: {status}"

class GrievanceAgent:
    def __init__(self):
        self.llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
        self.tools = [fetch_issue_history, notify_official, log_to_blockchain, draft_citizen_response]
        self.llm_with_tools = self.llm.bind_tools(self.tools)
        self.memory = MemorySaver()
        self.graph = self._build_graph()

    def _build_graph(self):
        graph = StateGraph(AgentState)

        graph.add_node("analyze", self._analyze_node)
        graph.add_node("tools", self._tool_node)
        graph.add_node("respond", self._respond_node)
        graph.add_node("escalate", self._escalate_node)

        graph.set_entry_point("analyze")
        graph.add_conditional_edges("analyze", self._route_after_analyze)
        graph.add_edge("tools", "analyze")
        graph.add_edge("respond", END)
        graph.add_edge("escalate", END)

        return graph.compile(checkpointer=self.memory)

    def _route_after_analyze(self, state: AgentState) -> str:
        last_message = state["messages"][-1]
        if hasattr(last_message, "tool_calls") and last_message.tool_calls:
            return "tools"
        elif state.get("severity") == "CRITICAL":
            return "escalate"
        else:
            return "respond"

    async def _analyze_node(self, state: AgentState) -> AgentState:
        response = await self.llm_with_tools.ainvoke([
            {"role": "system", "content": """You are a civic grievance agent.
            Analyze the issue, determine severity (LOW/MEDIUM/HIGH/CRITICAL),
            use tools to gather context, then draft a response."""},
            {"role": "user", "content": f"Issue: {state['description']}"}
        ])
        state["messages"] = [response]
        return state

    async def _tool_node(self, state: AgentState) -> AgentState:
        from langchain_core.messages import ToolMessage
        tool_calls = state["messages"][-1].tool_calls
        for tc in tool_calls:
            tool_fn = {t.name: t for t in self.tools}[tc["name"]]
            result = await tool_fn.ainvoke(tc["args"])
            state["messages"].append(
                ToolMessage(content=str(result), tool_call_id=tc["id"])
            )
        return state

    async def _respond_node(self, state: AgentState) -> AgentState:
        state["actions_taken"].append("responded")
        return state

    async def _escalate_node(self, state: AgentState) -> AgentState:
        state["escalated"] = True
        state["actions_taken"].append("escalated_to_official")
        return state

    async def process(self, issue_id: str, description: str) -> dict:
        state = AgentState(
            issue_id=issue_id,
            description=description,
            messages=[],
            actions_taken=[],
            severity="MEDIUM",
            escalated=False,
            resolution=None
        )
        config = {"configurable": {"thread_id": issue_id}}
        result = await self.graph.ainvoke(state, config)
        return result
```

### 6.6 Predictive Analytics Agent

```python
# services/agents/app/predictive_agent.py

from datetime import datetime, timedelta
from pydantic import BaseModel
from typing import List
import pandas as pd
from langchain_openai import ChatOpenAI

class Prediction(BaseModel):
    issue_type: str
    probability: float
    location: str
    predicted_date: datetime
    recommendation: str

class PredictiveAgent:
    def __init__(self, db):
        self.db = db
        self.llm = ChatOpenAI(model="gpt-4o-mini")

    async def analyze_patterns(self, constituency_id: str) -> List[Prediction]:
        rows = await self.db.fetch("""
            SELECT category, created_at, status, latitude, longitude
            FROM issues
            WHERE constituency_id = $1
            AND created_at > NOW() - INTERVAL '90 days'
        """, constituency_id)

        df = pd.DataFrame(rows)
        predictions = []

        if not df.empty:
            water = df[df['category'] == 'WATER']
            last_30 = water[water['created_at'] > datetime.now() - timedelta(days=30)]
            if len(last_30) > 0 and len(water) > 0:
                trend = len(last_30) / max(len(water), 1)
                if trend > 0.4:
                    predictions.append(Prediction(
                        issue_type="WATER_SHORTAGE",
                        probability=min(trend, 0.95),
                        location=constituency_id,
                        predicted_date=datetime.now() + timedelta(days=14),
                        recommendation="Pre-position tankers. Alert BWSSB ward engineer."
                    ))

            if datetime.now().month in [5, 6]:
                road = df[df['category'] == 'ROADS']
                if len(road) > 5:
                    predictions.append(Prediction(
                        issue_type="ROAD_DAMAGE_MONSOON",
                        probability=0.82,
                        location=constituency_id,
                        predicted_date=datetime.now() + timedelta(days=30),
                        recommendation="Identify and patch pothole clusters before June 15."
                    ))

        for p in predictions:
            context = f"Prediction: {p.issue_type}, Probability: {p.probability:.0%}"
            response = await self.llm.ainvoke(
                f"Generate a 2-sentence alert in English for ward officials. {context}"
            )
            p.recommendation = response.content

        return predictions

    async def run_daily(self):
        constituencies = await self.db.fetch("SELECT id FROM constituencies")
        for row in constituencies:
            preds = await self.analyze_patterns(str(row['id']))
            for p in preds:
                if p.probability > 0.7:
                    await self._alert_officials(str(row['id']), p)

    async def _alert_officials(self, constituency_id: str, pred: Prediction):
        pass
```

### 6.7 Database Schema Additions (Phase 4)

```sql
-- Agent sessions
CREATE TABLE agent_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_type VARCHAR(50) NOT NULL,
    user_id UUID REFERENCES users(id),
    issue_id UUID REFERENCES issues(id),
    thread_id VARCHAR(100) NOT NULL,
    messages JSONB DEFAULT '[]',
    actions JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Agent memory
CREATE TABLE agent_memory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    embedding vector(1536),
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_agent_memory_embed ON agent_memory
    USING ivfflat (embedding vector_cosine_ops) WITH (lists = 50);

-- Predictions log
CREATE TABLE predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    constituency_id UUID REFERENCES constituencies(id),
    issue_type VARCHAR(100) NOT NULL,
    probability FLOAT NOT NULL,
    predicted_date TIMESTAMP WITH TIME ZONE,
    recommendation TEXT,
    fulfilled BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Citizen chat history
CREATE TABLE citizen_chats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    message TEXT NOT NULL,
    response TEXT NOT NULL,
    language VARCHAR(5) DEFAULT 'kn',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 6.8 API Endpoints Added (Phase 4)

```
AGENT CHAT
+-- POST   /api/v1/assistant/chat           [Auth Required]
+-- GET    /api/v1/assistant/history        [Auth Required]

PREDICTIONS
+-- GET    /api/v1/agents/predictions       [Auth: Admin/Volunteer]

AGENT STATUS
+-- GET    /api/v1/agents/status            [Auth: Admin]
```

---

## 7. Phase 5: Scale - Federation & DAO Governance

### 7.1 Goal

Expand to multi-state. Introduce decentralized governance where citizens have token-based voting power and the platform itself becomes a DAO.

### 7.2 Scope

| Feature | Description |
|---------|-------------|
| Multi-state federation | Platform replicable to other states/parties |
| Citizen tokens | Participation tokens for governance of the platform |
| Quadratic voting | Reduce whale influence in polls |
| DAO governance | Citizens vote on platform features/policies |
| Token staking | Stake tokens to signal commitment |
| Cross-chain support | Polygon + Ethereum + Cosmos |
| Federated identity | One identity across all participating platforms |

### 7.3 Token Economics

```
+-----------------------------------------------------------------------------+
|                     JANABALA TOKEN (JANABALA)                               |
+-----------------------------------------------------------------------------+
|                                                                             |
|  EARNING JANABALA TOKENS                                                    |
|  +-- Report a verified issue: +5 JANABALA                                   |
|  +-- Issue resolved within 7 days: +10 JANABALA                            |
|  +-- Participate in poll: +2 JANABALA                                       |
|  +-- Correct prediction submitted: +20 JANABALA                            |
|  +-- Volunteer hours logged: +15 JANABALA/hour                              |
|                                                                             |
|  SPENDING JANABALA TOKENS                                                   |
|  +-- Create a new poll: -50 JANABALA                                        |
|  +-- Vote on platform governance proposal: -10 JANABALA                    |
|  +-- Stake for candidate support: variable                                  |
|                                                                             |
|  QUADRATIC VOTING FORMULA                                                   |
|  +-- Voting power = sqrt(tokens staked)                                     |
|  +-- 100 tokens = 10 votes, 400 tokens = 20 votes                          |
|  +-- Prevents plutocratic capture                                           |
|                                                                             |
+-----------------------------------------------------------------------------+
```

### 7.4 DAO Smart Contract

```solidity
// contracts/JanaBalaDAO.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/governance/Governor.sol";

contract JANABALAToken is ERC20 {
    address public minter;

    constructor() ERC20("JanaBala Token", "JANABALA") {
        minter = msg.sender;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == minter, "Only minter");
        _mint(to, amount);
    }
}

contract JanaBalaDAO {
    struct Proposal {
        uint256 id;
        string description;
        address proposer;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 endTime;
        bool executed;
    }

    JANABALAToken public token;
    uint256 public proposalCount;
    uint256 public votingPeriod = 7 days;
    uint256 public quorum = 100;

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string description, address proposer);
    event VoteCast(uint256 indexed proposalId, address voter, bool support, uint256 weight);

    constructor(address _token) {
        token = JANABALAToken(_token);
    }

    function propose(string calldata description) external returns (uint256) {
        require(token.balanceOf(msg.sender) >= 50e18, "Need 50 JANABALA to propose");

        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            proposer: msg.sender,
            forVotes: 0,
            againstVotes: 0,
            endTime: block.timestamp + votingPeriod,
            executed: false
        });

        emit ProposalCreated(proposalCount, description, msg.sender);
        return proposalCount;
    }

    function vote(uint256 proposalId, bool support) external {
        Proposal storage p = proposals[proposalId];
        require(block.timestamp < p.endTime, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;

        uint256 balance = token.balanceOf(msg.sender);
        uint256 weight = _sqrt(balance / 1e18);

        if (support) {
            p.forVotes += weight;
        } else {
            p.againstVotes += weight;
        }

        emit VoteCast(proposalId, msg.sender, support, weight);
    }

    function _sqrt(uint256 x) internal pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    function getResult(uint256 proposalId) external view returns (
        bool passed, uint256 forVotes, uint256 againstVotes
    ) {
        Proposal memory p = proposals[proposalId];
        return (
            p.forVotes > p.againstVotes && p.forVotes >= quorum,
            p.forVotes,
            p.againstVotes
        );
    }
}
```

### 7.5 Federation Protocol

```python
# services/federation/app/federation.py

from pydantic import BaseModel
from typing import List
import httpx

class FederatedNode(BaseModel):
    node_id: str
    name: str
    state: str
    api_url: str
    public_key: str
    verified: bool = False

class FederationProtocol:
    """
    Allows multiple JanaBala instances (different states/parties)
    to share anonymized data and best practices.
    """

    def __init__(self, this_node: FederatedNode):
        self.this_node = this_node
        self.known_nodes: List[FederatedNode] = []

    async def join_federation(self, bootstrap_url: str):
        """Register this node with the federation"""
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{bootstrap_url}/federation/join",
                json=self.this_node.dict()
            )
            self.known_nodes = [
                FederatedNode(**n) for n in response.json()["nodes"]
            ]

    async def share_anonymized_stats(self):
        """Share aggregated (non-PII) stats with federation"""
        stats = await self._get_anonymized_stats()
        for node in self.known_nodes:
            try:
                async with httpx.AsyncClient() as client:
                    await client.post(
                        f"{node.api_url}/federation/stats",
                        json=stats,
                        headers={"X-Node-ID": self.this_node.node_id}
                    )
            except Exception:
                pass

    async def _get_anonymized_stats(self) -> dict:
        return {
            "state": self.this_node.state,
            "total_issues": 0,
            "resolution_rate": 0.0,
            "top_categories": [],
            "active_users": 0
        }
```

### 7.6 Database Schema Additions (Phase 5)

```sql
-- JANABALA token balances (mirrored from blockchain)
CREATE TABLE token_balances (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    wallet_address VARCHAR(42) NOT NULL,
    balance DECIMAL(20, 6) DEFAULT 0,
    staked DECIMAL(20, 6) DEFAULT 0,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- DAO proposals (mirrored from blockchain)
CREATE TABLE dao_proposals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chain_proposal_id BIGINT NOT NULL,
    description TEXT NOT NULL,
    proposer_id UUID REFERENCES users(id),
    for_votes DECIMAL(20, 6) DEFAULT 0,
    against_votes DECIMAL(20, 6) DEFAULT 0,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    executed BOOLEAN DEFAULT FALSE,
    passed BOOLEAN,
    tx_hash VARCHAR(66),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Federation nodes
CREATE TABLE federation_nodes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    node_id VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    state VARCHAR(100) NOT NULL,
    api_url TEXT NOT NULL,
    public_key TEXT NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    last_seen TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## 8. NammaKasa Comparison

| Feature | NammaKasa | JanaBala |
|---------|-----------|----------|
| Core Focus | Fix garbage in Bengaluru | End-to-end digital democracy (all issues, budget, recall) |
| Platform | Simple Web App (browser only) | Offline-first Flutter Mobile App + Next.js Web Dashboard |
| Target Audience | Urban Bengaluru (always online) | Entire Karnataka including rural (works offline) |
| Issue Scope | Garbage only | 12+ categories: Roads, Water, Electricity, Healthcare, etc. |
| AI | None | Phase 2: Auto-classify urgency, translate Kannada, parse Govt Budget PDFs for RAG Q&A |
| Accountability | Leaderboard of complaints per MLA | Phase 2/3: Comprehensive Scorecards (attendance, promises vs reality, resolution %) + Right-to-Recall |
| User Identity | Anonymous (no login) | Tiered Auth (OTP for basic, Voter ID for voting) |
| Tamper-Proofing | Centralized DB | Phase 3: Polygon blockchain audit trail |

---

## 9. Competitive Analysis: What to Borrow from Global Platforms

### 9.1 Decidim (Barcelona, Spain)

Modular participatory democracy infrastructure used by 130+ institutions globally. Ruby on Rails, AGPL-3.0.

**Top 3 borrowings for JanaBala:**
1. **Modular "Spaces" architecture** — Decidim organizes everything into composable spaces (Processes, Assemblies, Consultations). JanaBala can structure itself around "Constituency Spaces" where Issues, Budgets, Polls, and Scorecards live together.
2. **Sortition (Random Selection)** — Randomly selects participants to eliminate bias. JanaBala can use this for citizen juries or audit committees in Phase 2+.
3. **Accountability tracking** — Divides results into projects and tracks implementation. Maps directly to Candidate Scorecards + Right-to-Recall workflow.

### 9.2 Consul (Madrid, Spain)

250+ cities globally (Madrid, São Paulo, Montevideo). Full participatory budgeting, debates, collaborative legislation. Ruby on Rails.

**Top 3 borrowings for JanaBala:**
1. **Participatory Budgeting workflow** — End-to-end flow (proposal → review → valuation → voting → execution) is production-proven. Adopt for Phase 2 Budget Transparency module.
2. **Multi-tenancy** — Single installation serves multiple cities/orgs. JanaBala needs this for wards, assembly constituencies, and parliamentary levels.
3. **SDG (Sustainable Development Goals) integration** — Links every participation activity to SDGs. Useful for grant applications (Omidyar, Mozilla, NDI).

### 9.3 DemocracyOS (Argentina)

Propose, debate, and vote on political proposals. Built by the Net Party in Buenos Aires. Node.js, 1.8k stars. Unmaintained since ~2017.

**Top 3 borrowings for JanaBala:**
1. **Debate quality algorithm** — Ranks arguments by substance (not popularity), filtering noise. JanaBala's citizen chat agent can use this logic.
2. **Minimal core loop** — Propose → Debate → Vote with deadline → Decision. Adopt this dead-simple flow for Phase 1 before adding features.
3. **Representative delegation (liquid democracy)** — Users delegate votes to trusted persons on specific topics. Add in Phase 5 for citizens who can't vote on every issue.

### 9.4 Active Citizen (Iceland)

Open-source AI-powered citizen empowerment library (TensorFlow, PredictionIO). EU-funded (CHEST project). Research-stage, not production.

**Top 3 borrowings for JanaBala:**
1. **AI content classification approach** — Used TensorFlow for proposal category/sentiment classification (2017). Adopt their approach with modern LLMs in Phase 2.
2. **Recommendation engine** — PredictionIO integration to recommend relevant groups/proposals. JanaBala can recommend similar issues, related budget items, or relevant polls.
3. **User-centric notification design** — Research patterns for citizen platform notifications. Apply to JanaBala's notification system (issue resolved, recall triggered, budget published).

### 9.5 Democracy Earth (Global/US)

YC-backed blockchain voting platform (Ethereum). 1.5k stars, MIT license. Focused solely on immutable vote recording. Stopped active development ~2020.

**Top 3 borrowings for JanaBala:**
1. **Immutable vote receipt on-chain** — Every vote casts an on-chain transaction with a receipt hash. Adopt this exact pattern for poll votes and Right-to-Recall triggers in Phase 3.
2. **Censorship-resistant architecture** — Not even platform operator can alter votes. Apply to Phase 3 blockchain layer.
3. **Token-based sybil resistance** — Token staking to prevent fake accounts. Use as alternative/supplement to Voter ID verification in Phase 5.

### 9.6 Ushahidi (Kenya)

Crisis mapping platform born from 2008 Kenyan post-election violence. Used in 160+ countries (Haiti earthquake, COVID-19, election monitoring). PHP.

**Top 3 borrowings for JanaBala:**
1. **Multi-channel ingestion (WhatsApp/SMS)** — Accepts reports via SMS, email, Twitter, web. Critical for rural Karnataka where WhatsApp is ubiquitous. Add to Phase 1 as second input channel.
2. **Map-based heatmap visualization** — 10+ years proven geospatial clustering. Use for issue density heatmaps by ward in Phase 1 dashboard.
3. **Verification triage workflow** — Manual + automated triage for crowdsourced reports. Phase 2 needs this to prevent fake/duplicate issue reporting.

### 9.7 Summary: JanaBala's Unique Position

| Platform | JanaBala has this? | What others lack |
|----------|-------------------|-----------------|
| **Offline-first mobile** | ✓ Phase 1 | None of the 6 have this |
| **AI classification** | ✓ Phase 2 | Only Active Citizen (research only) |
| **Budget RAG (PDFs)** | ✓ Phase 2 | None have this |
| **Blockchain audit** | ✓ Phase 3 | Only Democracy Earth (voting only) |
| **Agentic AI (autonomous)** | ✓ Phase 4 | None have this |
| **Candidate scorecards** | ✓ Phase 2 | Only NammaKasa (complaints count only) |
| **Multi-channel (SMS/WhatsApp)** | ✗ Borrow from Ushahidi (Phase 1+) | Ushahidi has this |
| **Participatory budgeting** | ✗ Borrow from Consul (Phase 2+) | Consul/Decidim have this |
| **Sortition / random selection** | ✗ Borrow from Decidim (Phase 3+) | Decidim has this |

### 9.8 Implementation Priority

1. **Immediate (Phase 1)**: Ushahidi's WhatsApp/SMS reporting — direct rural reach, low complexity
2. **Phase 2**: Consul's Participatory Budgeting workflow — core transparency feature
3. **Phase 3**: Decidim's modular Spaces architecture — long-term extensibility
4. **Phase 3+**: Democracy Earth's immutable vote receipts — trust layer
5. **Phase 4**: DemocracyOS debate quality algorithm — for citizen chat agent
6. **Phase 5**: Decidim's sortition + DemocracyOS liquid democracy — advanced governance

---

## 10. Why Offline-first Flutter + Next.js?

### 10.1 Rural Connectivity Reality

Karnataka has 32,000+ villages, many with spotty or no internet connectivity. An online-only app would exclude the very citizens UPP seeks to empower.

**Offline-first (SQLite local + background sync)** ensures the app works everywhere:
- Citizens in remote villages can report issues, browse data, and vote offline
- Data syncs automatically when connectivity is available
- Background sync handles retry with exponential backoff
- Conflict resolution via last-write-wins or manual merge

### 10.2 Flutter for Cross-Platform

Flutter gives **cross-platform (Android + iOS) from a single codebase**:
- Solo developer can maintain one codebase instead of two native apps
- Hot reload enables rapid iteration
- Rich widget library for Material Design 3 UI
- SQLite via sqflite for offline-first architecture
- Platform channels for native features (camera, GPS, push notifications)

### 10.3 Why Next.js for Web

Next.js provides **SEO for public dashboards**:
- Journalists, activists, and researchers can find issue data via Google search
- Server-side rendering for fast initial page loads
- Static generation for budget documents and reports
- API routes for lightweight serverless endpoints
- Proper admin interface with big screens and keyboards for volunteers/MLAs

---

## 11. Tiered Authentication Model

### 11.1 Tier 1 (OTP Only)

Accessible to all citizens with a phone number. Low friction, high adoption.

| Capability | Description |
|------------|-------------|
| View public dashboards | Browse issue maps, statistics, candidate scorecards |
| Read budget data | Query the RAG pipeline for budget insights |
| Report civic issues | Submit new issues with photos and location |
| Browse polls | View active and past poll results |

**Implementation:**
- SMS-based OTP via MSG91 / AWS SNS / Twilio
- 6-digit numeric OTP, 5-minute expiry
- OTP hashed with bcrypt before storage — never stored in plaintext
- Rate-limited to 3 OTP requests per phone per hour (token bucket)
- Brute-force protection: lockout after 5 failed attempts per phone per 30min window
- Session JWT valid for 7 days, refresh token with rotation for extended sessions
- JWT revocation: deny-list in Redis checked on each authenticated request

**Security Requirements:**
- `SECRET_KEY` must be > 256-bit entropy and checked at startup — app fails to boot if default detected
- CORS restricted to specific origins in production (no `*`)
- All API traffic over TLS 1.3 minimum

### 11.2 Tier 2 (Voter ID / EPIC Verification)

Required for binding actions. Provides verifiable digital identity.

| Capability | Description |
|------------|-------------|
| Cast votes in polls | Binding votes that count toward official results |
| Participate in Right-to-Recall | Trigger or sign recall petitions |
| Rate candidates | Submit candidate performance ratings |
| Propose agenda items | Suggest issues for official polls |

**Verification Flow**:
1. Citizen enters EPIC (Electoral Photo Identity Card) number
2. Digilocker/Setu API verifies EPIC matches name and constituency
3. System confirms EPIC belongs to same constituency as user's registered location
4. User's verification level upgrades to `tier2`

### 11.3 DB Schema Additions

```sql
-- EPIC number encrypted at rest (pgcrypto)
CREATE EXTENSION IF NOT EXISTS pgcrypto;
ALTER TABLE users ADD COLUMN epic_number_encrypted BYTEA;
ALTER TABLE users ADD COLUMN verification_level VARCHAR(10) DEFAULT 'tier1';
CREATE INDEX idx_users_verification ON users(verification_level);

-- OTP sessions updated for security
ALTER TABLE otp_sessions ADD COLUMN otp_hash VARCHAR(60) NOT NULL;  -- bcrypt hash
ALTER TABLE otp_sessions ADD COLUMN attempts INT DEFAULT 0;
ALTER TABLE otp_sessions ADD COLUMN locked_until TIMESTAMP WITH TIME ZONE;
-- column otp VARCHAR(6) is removed — only hash stored
```

---

## 12. Deployment & Infrastructure

### 12.1 Progressive Deployment Plan

| Phase | Platform | Est. Monthly Cost | Target Users | Key Services |
|-------|----------|------------------|--------------|--------------|
| Phase 1 | Railway/Render API + Supabase DB + Vercel Web | $0–$15 | < 1,000 | FastAPI, PostgreSQL, Next.js, Redis |
| Phase 2 | DigitalOcean App Platform + Managed PostgreSQL with pgvector | $50–$100 | < 10,000 | + LangGraph AI, Celery workers |
| Phase 3 | Azure App Service + Azure Postgres + Polygon Network | $200–$300 | < 50,000 | + Blockchain oracle, Smart contracts |
| Phase 4+ | Azure Kubernetes Service (AKS) + Redis Cluster | $500+ | 50,000+ | + Agent runtime, Predictive analytics |

**Migration Path:**
- Phase 1→2: Same DB, add pgvector extension, zero-downtime migration via Alembil
- Phase 2→3: Add blockchain service as sidecar — existing API unaffected
- Phase 3→4: Agent runtime runs as separate deployment; communicates via Redis/REST

### 12.2 Docker Compose (Local Dev - Full Stack)

```yaml
# infra/compose.yaml (modern Compose — no version key)

services:
  # Phase 1
  api:
    build: ../services/api
    ports: ["8000:8000"]
    env_file: .env
    depends_on: [db, redis]
    volumes: ["../services/api:/app"]

  web:
    build: ../apps/web
    ports: ["3000:3000"]
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1
    depends_on: [api]

  db:
    image: pgvector/pgvector:pg16
    ports: ["5432:5432"]
    environment:
      POSTGRES_DB: janabala
      POSTGRES_USER: janabala
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes: ["pgdata:/var/lib/postgresql/data"]

  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]

  # Phase 2
  ai_service:
    build: ../services/ai
    ports: ["8001:8001"]
    env_file: .env

  celery_worker:
    build: ../services/api
    command: celery -A app.workers.celery_app worker --loglevel=info
    env_file: .env
    depends_on: [redis, db]

  # Phase 3
  blockchain_service:
    build: ../services/blockchain
    ports: ["8002:8002"]
    env_file: .env

  # Phase 4
  agent_runtime:
    build: ../services/agents
    ports: ["8003:8003"]
    env_file: .env
    depends_on: [redis, db, ai_service]

volumes:
  pgdata:
```

---

## 13. Timeline & Milestones

### Pre-requisite (Week 0)
- Present Phase 1 blueprint to UPP (via email/social/events)
- Get buy-in for pilot ward (e.g., Ward 42, Bengaluru)
- Identify 10-20 active citizen volunteers

### Month 1: Foundation
- **Week 1**: DB Schema, API setup, Auth (OTP)
- **Week 2**: Flutter app basic UI (Login, Report Issue)
- **Week 3**: Offline Sync engine implementation
- **Week 4**: Web Dashboard MVP. **Deploy Phase 1 to pilot ward.**

### Month 2: Intelligence
- **Week 5**: Integrate LangGraph + OpenAI for Issue Classification
- **Week 6**: Budget PDF ingestion pipeline (Docling/PyMuPDF)
- **Week 7**: RAG query engine (pgvector) + Kannada translation
- **Week 8**: Candidate Scorecards UI. **Deploy Phase 2.**

### Month 3: Trust & Autonomy
- **Week 9**: Deploy Polygon Smart Contracts
- **Week 10**: Wire API to blockchain (Issue log, Vote receipts)
- **Week 11**: Grievance Agent (LangGraph) implementation
- **Week 12**: Predictive analytics. **Full Launch Pitch to UPP Leadership.**

---

## 14. How to Pitch to UPP

### 14.1 The Strategy

1. **Don't ask for money.** You are building a portfolio piece and a public good. Asking for money creates friction and expectations of deliverables.
2. **Don't ask for permission to build Phase 1.** Build it first, put it on your phone, then show them. A working demo is worth a thousand presentations.
3. **Target the pain point.** UPP has a great philosophy (ART) but no proven track record in office because they've never held office. This platform *is* the track record — it shows voters what UPP would do with data and technology.
4. **Lead with NammaKasa.** Show them the precedent: "A single developer built a garbage-reporting app in Bengaluru. Citizens love it. 50+ issues resolved. Here's JanaBala — the same idea, but for everything."
5. **Emphasize offline-first.** Rural Karnataka is UPP's heartland. Every other party ignores villages without internet. JanaBala works there.

### 14.2 The 30-Second Elevator Pitch (To Upendra or UPP Leaders)

> "Sir, Prajakeeya's ART philosophy is the future, but citizens need a tool to practice it daily. I've built JanaBala — an app that lets citizens report issues offline, tracks every government promise with AI, and creates a public scorecard for every representative. It works in villages without internet. NammaKasa proved Bengaluru wants this. I need one ward and 20 volunteers for a 4-week pilot. That's it. Can I show you a 2-minute demo?"

### 14.3 The Ask

- **Not Money.**
- "I need 1 ward to run a 4-week pilot."
- "I need 20 volunteers from that ward to test the app."
- "If it works, I want UPP to officially adopt the platform."
- Direct contact routes: DM Upendra on X/Twitter, attend a Prajakeeya event in Bengaluru, or get introduced via the podcast host who interviewed him.

---

## 15. Portfolio & Career Leverage

### 15.1 Resume Bullet Points

- **Architected "JanaBala"**: A state-level civic-tech platform for Karnataka's 224 constituencies using offline-first Flutter with local SQLite and background sync. Serves 32,000+ villages including areas without internet.
- **AI/RAG Implementation**: Built a multi-agent LangGraph pipeline for automated civic issue classification (12 categories, 4 urgency levels) and a pgvector-backed RAG engine extracting insights from government budget PDFs.
- **Blockchain Audit Trail**: Implemented Polygon-based smart contracts for tamper-proof logging of citizen issue reports and verifiable vote receipts. ~$0.0012/transaction.
- **Full-Stack Solo Dev**: Responsible for system architecture, Flutter mobile app, FastAPI backend, Next.js web dashboard, PostgreSQL schema, CI/CD, Docker deployment, and security controls across 5 phases.
- **Offline-First Sync Engine**: Designed an idempotent conflict-resolution sync protocol with exponential backoff, enabling reliable data flow between rural citizens and central servers.

### 15.2 Career Trajectories

1. **GovTech Specialist**: eGov Foundation, Samagra, Omidyar Network
2. **AI Engineer**: Your LangGraph/RAG implementation is production-grade
3. **Web3/DAO Engineer**: The Phase 3/5 implementation proves you can integrate traditional web2 apps with web3 audit layers
4. **CTO of UPP**: If the party gains traction, you are the architect of their digital infrastructure.

---

## 16. Security, Legal & Operational Readiness

### 16.1 Security Hardening Summary

| Threat | Mitigation | Implementation Phase |
|--------|-----------|-------------------|
| OTP interception | OTP hashed with bcrypt before storage; never stored in plaintext | Phase 1 |
| OTP brute-force | 5 failed attempts → 30min lockout per phone; token-bucket rate limit (3 req/hr) | Phase 1 |
| JWT theft | 7-day access + 30-day refresh token with rotation; Redis deny-list for revocation | Phase 1 |
| SMS credit drain | Rate-limit `send-otp` per IP + per phone; CAPTCHA after 3 requests from same IP | Phase 1 |
| PII leak (EPIC) | Encrypted at rest using pgcrypto (`epic_number_encrypted BYTEA`) | Phase 2 |
| SQL injection | All queries via SQLAlchemy ORM (parameterized); no raw SQL in application code | Phase 1 |
| XSS / CSRF | FastAPI auto-escapes JSON responses; Next.js built-in XSS protection; CSRF tokens for state-changing requests | Phase 1 |
| Admin abuse | Every admin action logged in `audit_log` table (who, what, when, IP) | Phase 1 |
| API abuse | Rate limiting per endpoint tier: auth (3/min), write (30/min), read (300/min); Redis-backed | Phase 1 |
| TLS | All production traffic over TLS 1.3; HSTS header; cert auto-renewal via Let's Encrypt | Phase 1 |
| Security headers | CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy configured in reverse proxy | Phase 1 |
| Secrets management | `SECRET_KEY` validated at boot (rejects defaults); SMS keys from env/file or Azure Key Vault | Phase 1 |
| Blockchain key | Oracle private key stored in Azure Key Vault / AWS KMS; never in env vars or code | Phase 3 |

### 16.2 Legal & Compliance Framework

**Digital Personal Data Protection Act, 2023 (DPDPA):**
- **Consent**: Explicit consent obtained at registration (phone + purpose + storage duration). Recorded in `consent_log` table.
- **Data Principal Rights**: API endpoints for access, correction, erasure, and portability under `GET /api/v1/user/data`, `DELETE /api/v1/user/data`.
- **Data Fiduciary**: JanaBala is a data fiduciary. Must appoint a Data Protection Officer (DPO) — can be the developer initially.
- **Breach Notification**: 72-hour window to report breaches to Data Protection Board. Runbook documented in Section 16.4.
- **Storage Limitation**: OTP sessions deleted after 7 days. Chat histories retained 90 days. Issue data retained per constituency term (5 years max).
- **Cross-border Transfer**: All data stored in India (Azure India South/Central regions).

**Representation of People Act, 1951:**
- Polls on JanaBala are **non-binding opinion polls** (not official elections) — explicitly disclaimed in the app
- Candidate scorecards use publicly available data (attendance records, prior statements) — verifiable sources cited
- Right-to-Recall feature is an **advocacy tool**, not a legal mechanism — disclaimer required
- Legal review recommended before allowing Tier 2 voting if results are presented as "constituency sentiment"

**Information Technology Act, 2000:**
- Section 79 safe harbour: JanaBala is an intermediary for user-generated content
- Takedown mechanism: `POST /api/v1/moderation/report` + review queue for admins
- Reasonable security practices (Section 43A): documented ISMS, regular audits
- Grievance officer: name and contact published on web dashboard (mandatory under IT Rules 2021)

**Cryptocurrency / Token Compliance (Phase 5):**
- JANABALA tokens may be classified as Virtual Digital Assets under Finance Act 2022
- 30% tax on transfers, 1% TDS under Section 194S
- Legal opinion recommended before token issuance
- Alternative: Non-transferable "participation points" stored only in PostgreSQL (not blockchain) to avoid VDA classification

**Open-Source License:**
- Recommended: **AGPL-3.0** (like Decidim) — ensures any modified version running as a service must release source
- License file: `LICENSE` at repo root
- All dependencies compatible (FastAPI = MIT, Flutter = BSD-3-Clause, LangGraph = MIT, web3.py = MIT)

### 16.3 Operational Readiness

**CI/CD Pipeline:**
- GitHub Actions with paths: `services/api/**` triggers API tests + build, `apps/flutter/**` triggers Flutter analyze + build
- Stages: lint → test → build → deploy staging → integration test → deploy production
- Flutter: `flutter analyze` + `flutter test` + build APK on PRs
- FastAPI: `ruff check` + `pytest` + build Docker image on push to main
- Staging environment: Railway/Render for API, Vercel preview for web

**Testing Strategy:**
| Layer | Tool | Scope | Target Coverage |
|-------|------|-------|-----------------|
| API unit | pytest + httpx | Routers, services, schemas | 90%+ |
| API integration | pytest + test DB | Full endpoint flows with PostgreSQL | 80%+ |
| Flutter unit | flutter_test | Models, services, providers | 80%+ |
| Flutter widget | flutter_test | Screen rendering, user interactions | 60%+ |
| Flutter E2E | patrol | Full user flows on device | Critical paths |
| Web | Playwright | Dashboard rendering, admin flows | Key pages |
| Security | OWASP ZAP | Automated DAST scan pre-release | Critical vulns |

**Logging, Monitoring & Observability:**
- **Structured logging**: JSON format with `service`, `level`, `timestamp`, `trace_id`, `user_id` (masked) — via Python `structlog` / Flutter `logging`
- **Metrics**: Prometheus metrics exposed at `/metrics` — request count, latency p50/p95/p99, error rate, queue depth
- **Dashboards**: Grafana dashboard per service (API, Celery, AI, Blockchain, Agent)
- **Alerting**: PagerDuty/Telegram alert on: error rate > 5%, p99 latency > 2s, queue backlog > 1000, OTP endpoint 4xx > 10%
- **Distributed tracing**: OpenTelemetry with trace propagation across FastAPI → Celery → AI service → Blockchain service
- **Log aggregation**: Loki (self-hosted if < 10GB/day) or Grafana Cloud (free tier: 50GB retention)

**Backup & Disaster Recovery:**
| Component | Backup Frequency | Retention | RTO | RPO |
|-----------|-----------------|-----------|-----|-----|
| PostgreSQL | Daily full + continuous WAL archiving | 30 days | 1 hour | 5 minutes |
| File uploads (S3/MinIO) | Cross-region replication | N/A | 15 min | N/A |
| Redis | Snapshot every 6 hours | 7 days | 30 min | 6 hours |
| Blockchain events | Replay from genesis block | Infinite | 1 hour | N/A |
| Config / env | Git-tracked (encrypted secrets) | Git history | 30 min | N/A |

**Incident Response Runbook:**
1. **Detection**: Alert via Grafana / uptime monitor (Better Uptime / Checkly)
2. **Triage** (15 min): Check Grafana dashboard for anomaly pattern; check recent deploy; check DB connection
3. **Mitigation**: Rollback last deploy / scale DB / restart service / toggle feature flag
4. **Resolution**: Fix root cause, deploy fix, verify
5. **Post-mortem**: Write incident doc within 48 hours; update runbook

**Feature Flags:**
- Simple Redis-backed flag store: `feature:phase2_ai` → `enabled` / `disabled` for specific constituencies or user cohorts
- Flags evaluated at request time — no deploy needed to toggle
- Key flags: `offline_sync_v2`, `ai_classification`, `blockchain_logging`, `agent_grievance`, `federation_mode`

### 16.4 Phase Transition Strategy

| Transition | Data Migration | Client Impact | Rollback |
|-----------|---------------|---------------|----------|
| Phase 1→2 | Add pgvector extension to existing PostgreSQL (zero-downtime). Backfill: Celery job re-classifies all existing issues via AI overnight | Old app versions continue working — new fields ignored | Drop pgvector extension, disable AI endpoints |
| Phase 2→3 | Add `wallet_address` nullable column to users (zero-downtime). Wallet generation happens lazily on first high-stakes action | Phase 2 API responses unchanged — new blockchain endpoints are additive | Disconnect blockchain service, revert to Phase 2 sync |
| Phase 3→4 | Add `agent_sessions`, `agent_memory` tables. No changes to existing tables | New chat endpoint added — existing polling/issue flows unaffected | Disable agent endpoints, clear agent tables |
| Phase 4→5 | Add `token_balances`, `dao_proposals`, `federation_nodes` tables. Token airdrop script for existing users based on participation history | DAO governance is opt-in (requires token claim). Existing users unaffected | DAO smart contracts are immutable — economic changes require new contract deploy |

**API Backward Compatibility:**
- All API responses return JSON — unknown fields are ignored by old clients
- Breaking changes (field renames, removal) go through `/api/v2/` prefix
- Deprecated endpoints return `Sunset` header with migration URL for 90 days
- Flutter app checks minimum API version at startup via `GET /api/v1/health` → `min_app_version` field

### 16.5 Architecture Deep-Dives

**Idempotency for Offline Sync:**
Each offline operation includes a client-generated `idempotency_key` (UUID). Server deduplicates on this key:
```python
# Server checks before processing
existing = await db.execute(
    select(SyncLog).where(SyncLog.idempotency_key == key)
)
if existing.scalar_one_or_none():
    return {"status": "duplicate", "existing_id": existing.id}
```

**Conflict Resolution Strategy:**
- **Last-Write-Wins** for simple fields (status, urgency) — compare `updated_at` timestamps
- **Manual Merge** for conflicting edits — flagged for admin review
- CRDT not implemented in Phase 1 (too complex for solo dev); deferred to Phase 2 if needed

**API Pagination Envelope:**
```json
{
  "data": [...],
  "pagination": {
    "cursor": "eyJpZCI6IjEyMyJ9",
    "has_more": true,
    "total": 142
  }
}
```
Cursor-based pagination for production; offset/limit for admin panels.

**File Upload Architecture:**
1. Client uploads to presigned S3/MinIO URL (obtained via `POST /api/v1/uploads/presign`)
2. Server never receives raw file bytes — reduces attack surface
3. Image auto-compressed via Sharp (Next.js side) or flutter_image_compress (app side)
4. Supported formats: JPEG, WebP (converted on upload), PNG
5. Max file size: 10MB per image, 5 images per issue

**Content Moderation:**
- **Automated**: Google Cloud Vision API / Azure Content Safety for image screening (Phase 2)
- **Manual**: Admin queue for flagged content with review/approve/remove actions
- **User reports**: `POST /api/v1/issues/:id/report` → moderation queue
- **Abuse prevention**: New users limited to 5 issues/day for first 7 days

**Admin Panel:**
- Next.js `/admin/*` routes with role-based access (`admin`, `volunteer`, `viewer`)
- Screens: Issue queue (assign, resolve, reject), User management, Moderation queue, Phase feature toggles, System health dashboard
- All admin actions logged to `audit_log` table with IP, user agent, timestamp

---

## 17. Cost Estimation (INR, 2026)

**Exchange rate:** 1 USD = ₹85 | **Date:** May 2026  

### 17.1 One-Time Costs

| Item | INR | USD |
|------|-----|-----|
| Google Play Developer account | ₹2,125 | $25 |
| Apple Developer Program (Year 1) | ₹8,415 | $99 |
| Domain name (.in, 1 year) | ₹700 | $8 |
| SSL certificate (Let's Encrypt) | ₹0 | $0 |
| Polygon contract deployments (all phases) | ₹513 | $6 |
| Flutter / Docker / GitHub (all free) | ₹0 | $0 |
| **Total One-Time** | **₹11,753** | **$138** |

### 17.2 Phase-by-Phase Running Costs

| Phase | Users | Daily | Monthly | Yearly | Cost/User/Mo |
|-------|-------|-------|---------|--------|-------------|
| **P1** Foundation | < 1,000 | ₹19 | ₹573 | ₹18,116 | ₹0.57 |
| **P2** Intelligence | < 10,000 | ₹136 | ₹4,073 | ₹57,991 | ₹0.41 |
| **P3** Trust (Blockchain) | < 50,000 | ₹445 | ₹13,347 | ₹1,69,292 | ₹0.27 |
| **P4** Autonomy (Agentic AI) | < 50,000 | ₹1,205 | ₹36,154 | ₹4,42,963 | ₹0.72 |
| **P5** Scale (DAO & Federation) | < 100,000 | ₹2,477 | ₹74,320 | ₹9,01,455 | ₹0.74 |

### 17.3 Phase 1 — Foundation (₹573/mo)

| Service | Plan | INR/mo |
|---------|------|--------|
| Railway (FastAPI backend) | Hobby ($5) | ₹425 |
| Supabase PostgreSQL | Free (500MB) | ₹0 |
| Vercel (Next.js dashboard) | Free (Hobby) | ₹0 |
| Upstash Redis | Free (256MB) | ₹0 |
| MSG91 OTP (500 OTPs × ₹0.25 + 18% GST) | Pay-per-use | ₹148 |
| GitHub / Grafana / Sentry / CI | All free tiers | ₹0 |
| **Total** | | **₹573** |

### 17.4 Phase 2 — Intelligence (₹4,073/mo)

| Service | Plan | INR/mo |
|---------|------|--------|
| DigitalOcean App Platform | 1vCPU/1GB | ₹1,020 |
| DO Managed PostgreSQL (pgvector) | Basic 1GB | ₹1,288 |
| Celery worker (DO job) | 1vCPU/512MB | ₹425 |
| MSG91 OTP (5,000 × ₹0.20 + GST) | Volume pack | ₹1,180 |
| OpenAI gpt-5.4-nano (classification + RAG queries) | ~3M tokens/mo | ₹142 |
| OpenAI text-embedding-3-small | ~300K tokens/mo | ₹1 |
| Upstash Redis | Pay-as-you-go | ₹17 |
| **Total** | | **₹4,073** |

### 17.5 Phase 3 — Trust (₹13,347/mo)

| Service | Plan | INR/mo |
|---------|------|--------|
| Azure App Service (B1, Central India) | 1 core / 1.75GB | ₹1,117 |
| Azure PostgreSQL Flexible (B1ms, Central India) | 1 vCore / 2GB + 32GB | ₹1,480 |
| Celery worker (Azure B1) | Additional instance | ₹1,117 |
| Vercel Pro | 1 seat | ₹1,700 |
| MSG91 OTP (25,000 × ₹0.18 + GST) | Volume pack | ₹5,310 |
| OpenAI (classification + RAG — 15M tokens/mo) | gpt-5.4-nano | ₹704 |
| Pinata IPFS (Picnic plan) | 1TB storage | ₹1,700 |
| Polygon gas fees (~1,000 txns) | ~₹0.10 avg/txn | ₹100 |
| Upstash Redis | Pay-as-you-go | ₹34 |
| **Total** | | **₹13,347** |

### 17.6 Phase 4 — Autonomy (₹36,154/mo)

| Service | Plan | INR/mo |
|---------|------|--------|
| Azure AKS (Standard, Central India) | Control plane | ₹5,475 |
| AKS node pool (2 × D2s v3) | 2 nodes | ₹9,520 |
| Azure PostgreSQL Flexible (D2ds v5) | 2 vCore / 8GB | ₹5,950 |
| Vercel Pro | 1 seat | ₹1,700 |
| MSG91 OTP (25,000 × ₹0.18 + GST) | Volume pack | ₹5,310 |
| OpenAI gpt-5.4-mini (5 agents — 22.5M tokens/mo) | Agent reasoning | ₹3,825 |
| OpenAI gpt-5.4-nano (classification — 15M tokens/mo) | Bulk | ₹701 |
| OpenAI embeddings (2M tokens/mo) | | ₹3 |
| Upstash Redis (Fixed 1GB) | | ₹1,700 |
| Pinata IPFS (Picnic) | 1TB | ₹1,700 |
| Polygon gas fees (~1,000 txns) | | ₹100 |
| Azure Storage (64GB) | | ₹170 |
| **Total** | | **₹36,154** |

### 17.7 Phase 5 — Scale (₹74,320/mo)

| Service | Plan | INR/mo |
|---------|------|--------|
| Azure AKS (Standard, Central India) | Control plane | ₹5,475 |
| AKS node pool (3 × D2s v3) | 3 nodes | ₹14,280 |
| Azure PostgreSQL Flexible (D4ds v5) | 4 vCore / 16GB | ₹11,900 |
| Vercel Pro (2 seats) | | ₹3,400 |
| MSG91 OTP (50,000 × ₹0.17 + GST) | Max volume | ₹10,030 |
| OpenAI gpt-5.4-mini (agents — 45M tokens/mo) | | ₹7,651 |
| OpenAI gpt-5.4-nano (bulk — 30M tokens/mo) | | ₹1,403 |
| OpenAI embeddings (5M tokens/mo) | | ₹9 |
| Upstash Redis (Fixed 5GB) | | ₹8,500 |
| Pinata IPFS (Fiesta, 5TB) | | ₹8,500 |
| Polygon gas fees (~5,000 txns) | Governance | ₹500 |
| Federation servers (2 × DO droplets) | $12/mo each | ₹2,040 |
| Token infrastructure | Smart contract ops | ₹250 |
| Azure Storage (128GB) | | ₹340 |
| **Total** | | **₹74,320** |

### 17.8 Per-Unit Cost Reference

| Resource | Unit | Cost (INR) |
|----------|------|------------|
| MSG91 OTP SMS | per SMS | ₹0.16–0.25 + 18% GST |
| OpenAI gpt-5.4-nano input | per 1M tokens | ₹17 |
| OpenAI gpt-5.4-nano output | per 1M tokens | ₹106 |
| OpenAI gpt-5.4-mini input | per 1M tokens | ₹64 |
| OpenAI gpt-5.4-mini output | per 1M tokens | ₹383 |
| OpenAI embeddings (3-small) | per 1M tokens | ₹1.70 |
| Polygon gas fee | per transaction | ₹0.05–₹0.50 |
| Azure App Service B1 (India) | per month | ₹1,117 |
| Azure PostgreSQL B1ms (India) | per month | ₹1,480 |
| DigitalOcean 1vCPU/1GB | per month | ₹1,020 |
| AKS control plane | per month | ₹5,475 |

---

## 18. Sponsorship & Funding Sources

### 18.1 Immediate Actions (This Week — ₹0 Cost)

| Action | Value | How |
|--------|-------|-----|
| DPGA registration | Gateway to all institutional grants | app.digitalpublicgoods.net/signup — 2 hrs, SDG 16 alignment |
| GitHub Sponsors | ₹8,500–85,000/mo ongoing | github.com/sponsors/accounts — zero fees, INR payout |
| Open Collective | ₹42,500–8.5L/yr transparent | opencollective.com/signup — donations with fiscal host |
| AWS Activate Founders | ₹85K credits instantly | aws.amazon.com/activate — instant approval |
| Microsoft for Startups | ₹1.25Cr Azure credits | microsoft.com/startups — Azure certs strengthen case |
| Google Cloud for Startups | ₹1.7Cr credits | cloud.google.com/startup/apply |
| Vercel OSS sponsorship | Free Pro plan | oss@vercel.com with repo link |
| Supabase OSS program | Free Pro plan | support@supabase.io |

### 18.2 Short-Term (1–3 Months)

| Source | Amount (INR) | Requirements |
|--------|-------------|--------------|
| **FOSS United grant** | ₹3–15L | Working code, FOSS license, 1 community engagement/quarter. Apply at grants@fossunited.org |
| **Rohini Nilekani Philanthropies** | ₹10L–1Cr | Open-source public good. Email team@rohininilekani.org with concept note |
| **GSoC 2027 mentor org** | ₹1.25–2.75L per student (Google pays directly) | Apply Jan 2027 as mentor org. Google pays students to code on JanaBala |

### 18.3 Medium-Term (3–12 Months)

| Source | Amount (INR) | Strings |
|--------|-------------|---------|
| **Mozilla "Democracy x AI" Incubator** | ₹40–85L | Open-source, trustworthy AI. Watch foundation.mozilla.org for next cohort |
| **Omidyar Network India** | ₹40L–4Cr | Relationship-driven. Send concept note to info@omidyarnetwork.in |
| **NDI (National Democratic Institute)** | ₹20L–1.7Cr | **Must be non-partisan** — can't be UPP-exclusive |
| **Shuttleworth Fellowship** | ₹2.3Cr/yr | Full-time commitment, 1% acceptance. shuttleworthfoundation.org/apply |
| **Ford Foundation India** | ₹85L–8.5Cr | Invitation-only. Send concept note to New Delhi office after 1+ yr traction |
| **UNDP India Accelerator Lab** | ₹8.5–85L | SDG alignment, government partnership preferred |

### 18.4 Revenue Model (6–12 Months Out)

| Model | Revenue (INR) | Notes |
|-------|-------------|-------|
| Deploy JanaBala for other states (TN, MH, KA) | ₹5–25L per deployment | Customization + training + support |
| White-label for other political parties | ₹5–50L per engagement | AGPL-3.0 allows self-hosting but most parties lack tech capacity |
| Government contracts (Smart Cities, eGov) | ₹10–50L per contract | Pitch to Karnataka IT dept, Smart Cities Mission |
| Consulting on top of AGPL-3.0 moat | Variable | Anyone modifying must release source — makes your expertise irreplaceable |

---

## 19. Legal Entity & Funding Strategy

### 19.1 Why Not to Take UPP Money

| If UPP funds JanaBala | Consequence |
|-----------------------|-------------|
| NDI, Ford, Mozilla, UNDP grants | **Disqualified** — all require non-partisan status |
| FCRA (Foreign Contribution Regulation Act) | **Blocked** — party + foreign funding mix is illegal |
| Credibility as "public good" | **Destroyed** — perceived as party tool |
| DPG (Digital Public Good) certification | **At risk** — certification requires non-partisan governance |
| 80G tax deduction for Indian donors | **Not possible** — party doesn't qualify |

### 19.2 Recommended Legal Structure

**Register a Section 8 non-profit company** as JanaBala's legal entity:

| Aspect | Detail |
|--------|--------|
| Entity type | Section 8 Company (non-profit) under Companies Act 2013 |
| Registration time | 2–4 weeks (CA + MCA filing) |
| Registration cost | ₹5,000–₹15,000 (one-time) |
| Benefits | 80G tax exemption for donors, FCRA eligibility, credibility for grants |
| UPP relationship | UPP is a **user**, not a funder. Individual UPP members can donate personally |
| Board composition | 3 directors — tech founder, civic activist, legal/finance professional |

### 19.3 Priority Action Plan

| Priority | Action | Effort | Timeline | Value |
|----------|--------|--------|----------|-------|
| 1 | Register as Digital Public Good (DPGA) | 2 hrs | Week 1 | Gateway to all institutional funding |
| 2 | Set up GitHub Sponsors | 1 hr | Week 1 | ₹8,500–85K/mo ongoing |
| 3 | Set up Open Collective | 1 hr | Week 1 | Transparent donation channel |
| 4 | Apply Microsoft for Startups | 30 min | Week 1 | ₹1.25Cr Azure credits |
| 5 | Apply AWS Activate Founders | 15 min | Week 1 | ₹85K credits instantly |
| 6 | Apply Google Cloud for Startups | 30 min | Week 1 | ₹1.7Cr credits |
| 7 | Apply Vercel / Supabase OSS programs | 30 min each | Week 1 | Free hosting + DB |
| 8 | Apply FOSS United project grant | 2 hrs | Month 1 | ₹3–15L |
| 9 | Email Rohini Nilekani Philanthropies | 3 hrs (concept note) | Month 1 | ₹10L–1Cr |
| 10 | Register Section 8 non-profit company | 2–4 weeks | Month 1–2 | Unlocks all grant eligibility |
| 11 | Register as GSoC mentor org | 4 hrs | Jan 2027 | Funded contributors |
| 12 | Watch Mozilla Incubator next cycle | 1 hr (register interest) | Ongoing | $50–100K |

### 19.4 Self-Funding Feasibility

| Phase | Monthly Cost | Self-Fundable? |
|-------|-------------|----------------|
| Phase 1 | ₹573/mo | **Yes** — pocket money |
| Phase 2 | ₹4,073/mo | **Yes** — cloud credits cover this (Microsoft $150K ≈ 12 years of P2) |
| Phase 3 | ₹13,347/mo | **Yes** — cloud credits + GitHub Sponsors + FOSS United cover this |
| Phase 4 | ₹36,154/mo | **Stretch** — needs grant funding or revenue by this point |
| Phase 5 | ₹74,320/mo | **Needs grants** — grants + consulting + state deployments combined |

Phase 1 costs **₹19/day** — order of a single chai. Even Phase 3 at ₹445/day is within reach for 2–3 years with cloud credits alone.

---

*Built for the citizens of Karnataka.*  
*A step towards true Direct Democracy.*
