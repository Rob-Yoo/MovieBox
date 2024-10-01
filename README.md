# 무비박스 <img src="https://github.com/user-attachments/assets/601ae563-3310-4e59-a310-64ce9bc7e340" width="35" height="35" >
 > 기억에 남는 영화를 찾아 나만의 코멘트를 남기고, 영화 카드로 보관할 수 있는 영화 기록 앱
<a href="" target="_blank">
  <img width="130" alt="appstore" src="https://user-images.githubusercontent.com/55099365/196023806-5eb7be0f-c7cf-4661-bb39-35a15146c33a.png">
</a>

## 🗄️ 프로젝트 정보
- **기간** : `2024.09.19 ~ 2024.09.30` (약 1주)
- **개발 인원** : `iOS 1명`
- **지원 버전**: <img src="https://img.shields.io/badge/iOS-16.0+-black?logo=apple"/>
- **기술 스택 및 라이브러리** :   
  - UI: `SwiftUI` `Shufflelt` `SwiftUIVisualEffects` `Cosmos` `YouTubePlayerKit`
  - Reactive: `Combine`
  - Network: `Moya`
  - 로컬 저장소: `Realm`
  - 이미지 처리: `Nuke` `NukeUI`
  - DI Container: `Swinject`
- **프로젝트 주요 기능**

  - `영화 카드 컬렉션 기능`
    
      - 카드 덱과 카드 앞뒷면 구현을 통한 직관적인 카드 UI/UX 제공
      - 별점 / 코멘트 기능

  - `영화 검색 기능`
  
    - 주간 인기 영화 목록 조회
    - 영화 키워드 검색
        - 무한 스크롤 기능
  
  - `영화 상세 정보 조회`
      
      - 영화 기본 정보 제공
      - 포토 갤러리 / 동영상 / 비슷한 영화 / 추천 영화 컨텐츠 제공

<br>

## 🧰 프로젝트 주요 기술 사항

### DI Container를 활용한 Clean Architecture + MVVM

> 영화 상세 정보 및 영화 카드 제작 기능에서의 Clean Architecture 활용 예시

<br>

<b> Data 계층 </b>

<image src="https://github.com/user-attachments/assets/da066701-9b3e-4e2a-ae5f-184c25fd32f7" width="900">

<br>
<br>

<b> Domain 계층 </b>
<br>

<image src="https://github.com/user-attachments/assets/a77a72a9-5fcc-4b78-af68-0b1d6e31c3ca" width="700" >
        
- Presentation 계층

    - MovieContentViewModel
        - MovieContentUseCase 프로토콜에 의존하여 MovieContent Entiy를 각각의 Presentation Model로 변환하여 Output에 바인딩
