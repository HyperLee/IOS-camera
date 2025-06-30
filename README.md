# iOS Camera App - 相機應用程式

一個功能豐富的 iOS 相機應用程式，使用 Objective-C 開發，提供專業的相機控制功能。

## 專案概述

這是一個基於 AVFoundation 框架開發的 iOS 相機應用程式，提供了完整的相機控制功能，包括閃光燈控制、ISO 設定、前後鏡頭切換以及縮放功能。應用程式採用原生 iOS 開發，針對手機攝影需求進行了優化。

## 主要功能

### 📸 核心相機功能
- **即時相機預覽**: 使用 AVCaptureVideoPreviewLayer 提供流暢的相機預覽
- **拍照功能**: 高品質照片拍攝，支援 JPEG 格式輸出
- **前後鏡頭切換**: 支援前置和後置鏡頭無縫切換
- **全螢幕預覽**: 適配不同螢幕尺寸的預覽界面

### 💡 光線控制
- **閃光燈模式**:
  - 自動閃光燈 (Auto)
  - 開啟閃光燈 (On)
  - 關閉閃光燈 (Off)
- **手電筒模式**:
  - 自動手電筒 (Torch Auto)
  - 開啟手電筒 (Torch On)
  - 關閉手電筒 (Torch Off)

### ⚙️ 專業設定
- **ISO 控制**: 
  - 支援 ISO 50、100、200、400 四個檔位
  - 使用 UIPickerView 進行直觀選擇
  - 即時調整相機感光度
- **縮放功能**: 
  - 雙指捏合手勢進行縮放
  - 平滑的縮放動畫效果
  - 支援最大縮放倍率限制

### 🎯 使用者體驗
- **直觀操作界面**: 簡潔易用的控制按鈕佈局
- **手勢支援**: 支援捏合縮放手勢
- **即時回饋**: 設定變更即時生效
- **穩定性保證**: 完善的錯誤處理機制

## 技術架構

### 核心框架
- **AVFoundation**: 相機硬體控制和媒體處理
- **AssetsLibrary**: 照片庫存取 (相容性支援)
- **UIKit**: 使用者界面框架
- **Core Animation**: 動畫效果處理

### 主要組件

#### AVCaptureSession 管理
```objective-c
@property (nonatomic, strong) AVCaptureSession* session;
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
```

#### 控制元件
- **switchCarmeraSegment**: 前後鏡頭切換控制
- **flashButton**: 閃光燈控制按鈕
- **isoPickerView**: ISO 選擇器
- **backView**: 相機預覽容器

#### 手勢識別
- **UIPinchGestureRecognizer**: 縮放手勢識別
- **手勢代理**: 處理縮放開始和結束事件

## 系統需求

- **iOS 版本**: iOS 8.0 或更高版本
- **設備需求**: iPhone/iPad 與相機硬體
- **開發環境**: Xcode 7.0 或更高版本
- **程式語言**: Objective-C
- **架構支援**: armv7 及更高

## 安裝說明

### 開發環境設置
1. **安裝 Xcode**: 從 Mac App Store 下載最新版本的 Xcode
2. **克隆專案**:
   ```bash
   git clone https://github.com/HyperLee/IOS-camera.git
   cd IOS-camera
   ```

3. **開啟專案**:
   ```bash
   open noveltek/noveltek.xcodeproj
   ```

### 建置和執行
1. 在 Xcode 中選擇目標設備或模擬器
2. 按下 `⌘ + R` 建置並執行專案
3. 確保設備已連接並信任開發者憑證

### 權限設定
應用程式需要以下權限 (已在 Info.plist 中配置):
- **NSCameraUsageDescription**: 相機存取權限
- **NSPhotoLibraryUsageDescription**: 照片庫存取權限
- **NSAppleMusicUsageDescription**: 媒體庫存取權限

## 使用指南

### 基本操作
1. **啟動應用程式**: 首次啟動時會請求相機權限
2. **拍照**: 點擊拍照按鈕進行拍攝
3. **切換鏡頭**: 使用分段控制器切換前後鏡頭
4. **調整閃光燈**: 點擊閃光燈按鈕循環切換模式

### 進階功能
1. **ISO 調整**:
   - 點擊 ISO 按鈕顯示選擇器
   - 滾動選擇所需的 ISO 值
   - 再次點擊按鈕隱藏選擇器

2. **縮放操作**:
   - 使用雙指在預覽畫面上捏合
   - 放大: 手指向外撥動
   - 縮小: 手指向內捏合

### 控制項說明
- **前後鏡頭切換**: 頂部分段控制器
- **閃光燈控制**: 導航欄右側按鈕
- **ISO 設定**: 專用 ISO 按鈕
- **拍照**: 底部拍照按鈕

## 檔案結構

```
noveltek/
├── noveltek/                    # 主要應用程式目錄
│   ├── AppDelegate.h           # 應用程式代理標頭檔
│   ├── AppDelegate.m           # 應用程式代理實作
│   ├── ViewController.h        # 主視圖控制器標頭檔
│   ├── ViewController.m        # 主視圖控制器實作 (核心功能)
│   ├── main.m                  # 應用程式入口點
│   ├── Info.plist             # 應用程式配置檔案
│   ├── Base.lproj/            # 本地化資源
│   │   └── Main.storyboard    # 主要 UI 佈局
│   └── Launch Screen.xib      # 啟動畫面
├── noveltekTests/              # 測試檔案目錄
│   ├── noveltekTests.m        # 單元測試
│   └── Info.plist             # 測試配置
└── noveltek.xcodeproj/         # Xcode 專案檔案
    ├── project.pbxproj        # 專案建置配置
    └── xcuserdata/            # 使用者資料
```

## 程式碼說明

### 核心類別

#### ViewController
主要的視圖控制器，處理所有相機相關功能:

**主要屬性**:
- `session`: AVCaptureSession 實例，管理相機會話
- `videoInput`: 視訊輸入設備
- `stillImageOutput`: 靜態圖像輸出
- `previewLayer`: 預覽圖層
- `effectiveScale`: 當前縮放比例

**核心方法**:
- `initAVCaptureSession`: 初始化相機會話
- `setUpGesture`: 設定手勢識別
- `setCameraISO:completionHandler:`: 設定 ISO 值
- `handlePinchGesture:`: 處理縮放手勢

### 設計模式
- **代理模式**: 使用 UIGestureRecognizerDelegate 處理手勢
- **MVC 架構**: 清晰的模型-視圖-控制器分離
- **Target-Action**: UI 控制項事件處理

## 開發注意事項

### 相機權限處理
- 應用程式會在首次使用時請求相機權限
- 必須在 Info.plist 中提供權限使用說明
- 處理權限拒絕的情況

### 設備相容性
- 確保設備支援相機功能
- 檢查前置相機可用性
- 處理不同設備的螢幕尺寸

### 效能優化
- 在 viewWillAppear 中啟動相機會話
- 在 viewDidDisappear 中停止相機會話
- 使用異步隊列處理相機操作

### 記憶體管理
- 正確使用 weak/strong 屬性修飾符
- 及時釋放相機資源
- 避免循環引用

## 疑難排解

### 常見問題

**Q: 應用程式無法存取相機**
A: 檢查設備設定中的隱私權設定，確保允許應用程式存取相機

**Q: 預覽畫面顯示異常**
A: 確認設備方向設定，應用程式僅支援直向模式

**Q: ISO 設定無效**
A: 確保設備支援手動 ISO 控制，部分舊設備可能不支援

**Q: 縮放功能無反應**
A: 檢查手勢識別器設定，確保 UIPinchGestureRecognizer 正確配置

### 除錯建議
1. 使用 Xcode 的除錯器檢查相機會話狀態
2. 檢查控制台輸出的錯誤訊息
3. 驗證設備相機硬體功能
4. 測試不同的 iOS 版本相容性

## 版本歷史

- **v1.0** (2016-03-14): 初始版本
  - 基本相機拍攝功能
  - 閃光燈控制
  - 前後鏡頭切換
  - ISO 手動控制
  - 縮放功能

## 授權條款

版權所有 (c) 2016年 noveltek. 保留所有權利。

## 貢獻指南

歡迎提交 Pull Request 或 Issue:
1. Fork 此專案
2. 建立功能分支
3. 提交您的更改
4. 建立 Pull Request

## 聯繫方式

如有問題或建議，請通過 GitHub Issues 與我們聯繫。

---

**注意**: 本應用程式為學習和展示目的開發，請確保在正式環境中進行充分測試。
