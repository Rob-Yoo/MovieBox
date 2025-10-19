# 무비박스 <img src="https://github.com/user-attachments/assets/601ae563-3310-4e59-a310-64ce9bc7e340" width="35" height="35" >
 > 기억에 남는 영화를 찾아 나만의 코멘트를 남기고, 영화 카드로 보관할 수 있는 영화 기록 앱
<a href="https://apps.apple.com/kr/app/%EB%AC%B4%EB%B9%84%EB%B0%95%EC%8A%A4/id6711330901" target="_blank">
  <img width="130" alt="appstore" src="https://user-images.githubusercontent.com/55099365/196023806-5eb7be0f-c7cf-4661-bb39-35a15146c33a.png">
</a>

<br>

| 무비박스 화면 | 영화 검색 화면 | 영화 상세 정보 화면 | 영화 카드 제작 화면 |
|--|--|--|--|
|![Simulator Screen Recording - iPhone 15 Pro - 2024-10-01 at 01 09 00](https://github.com/user-attachments/assets/0d30240c-14ed-4f58-b8fc-128596e917e4)|![Simulator Screen Recording - iPhone 15 Pro - 2024-10-07 at 03 57 40](https://github.com/user-attachments/assets/4b8cd764-fbc6-4bdd-9d38-6ba52323463f)|![Simulator Screen Recording - iPhone 15 Pro - 2024-10-07 at 03 59 38](https://github.com/user-attachments/assets/859f5c49-ff97-4021-9856-6fca9b951879)|![Simulator Screen Recording - iPhone 15 Pro - 2024-10-07 at 04 26 20](https://github.com/user-attachments/assets/b445d162-801c-4e8c-ad13-5853fa9939f5)|

<br>

## 🗄️ 프로젝트 정보
- **기간** : `2024.09.19 ~ 2024.09.30` (약 1주)
- **개발 인원** : `iOS 1명`
- **지원 버전**: <img src="https://img.shields.io/badge/iOS-16.0+-black?logo=apple"/>
- **기술 스택 및 라이브러리** :   
  - UI: `SwiftUI` `Shufflelt` `SwiftUIVisualEffects` `Cosmos` `YouTubePlayerKit`
  - Reactive: `Combine`
  - Network: `Moya`
  - 로컬 저장소: `Realm`
  - DI Container: `Swinject`
- **프로젝트 주요 기능**

  - `영화 카드 컬렉션 기능`
    
      - 카드 덱과 카드 앞뒷면 구현을 통한 직관적인 카드 UI/UX 제공
      - 별점 / 코멘트 기능

  - `영화 검색 기능`
  
    - 주간 인기 영화 목록 조회
    - 영화 키워드 검색
        - 무한 스크롤 기능
  
  - `영화 상세 정보 조회 기능`
      
      - 영화 기본 정보 제공
      - 포토 갤러리 / 동영상 / 비슷한 영화 / 추천 영화 컨텐츠 제공

<br>

## 🧰 프로젝트 주요 기술 사항

### 이미지 캐시 전략 및 구현

<br>
<b> 이미지 캐시 전략 </b>
<br>
<br>
<img src="https://github.com/user-attachments/assets/6dab8c2b-ac22-4e0f-bc4f-c9637c889961" width="800">

<br>
<br>

- <b>영화 검색 결과</b>에 대한 이미지는 사용자가 빠르게 소비하는 <b>단기적인 데이터</b>이므로 NSCache를 이용한 <b>메모리 캐시</b>만 적용
 
- <b>주간 인기 영화</b>에 대한 이미지는 주 단위로 바뀌는 <b>장기적인 데이터</b>이므로 FileManager를 이용한 <b>Etag 기반 디스크 캐시</b>만 적용
   - 20개의 데이터 중 평균적으로 3-4개의 데이터만 업데이트 되기에 주 단위로 모든 데이터를 제거하는 것이 아니라 변동된 데이터만 삽입/삭제
   
- <b>영화 상세 정보</b>에 대한 이미지는 사용자가 <b>관람할 영화를 고르기 위해 해당 화면에 접근 후 앱을 종료한 뒤 영화 관람 후 다시 앱을 실행하여 영화 카드를 제작하는 시나리오</b>를 고려하여 <b>메모리 캐시와 Etag 기반 디스크 캐시</b>를 혼합하여 적용
   - 디스크 캐시 히트율을 높히기 위해 <b>LRU와 LFU를 혼합한 디스크 캐시</b> 적용

<br>
<br>

<b> LRU와 LFU 알고리즘을 혼합한 디스크 캐시 구현 </b>

<br>
<br>

<img src="https://github.com/user-attachments/assets/fa39a664-efd0-4b51-a594-48c420ddbad8" width="800">

<br>
<br>

- LRU 알고리즘을 구현 시 접근 시간에 대한 max 연산의 O(N) 시간복잡도를 <b>이중 연결 리스트를 사용하여 O(1)로 개선</b>
- 메인 스레드에서의 I/O Bound 문제를 해결하고 I/O 작업 중 발생할 수 있는 Data Race를 방지하기 위해, <b>Custom Serial Queue를 활용한 Non-Blocking I/O</b> 적용

<br>
<br>

### 이미지 리사이징을 활용한 메모리 최적화

<br>

<div align="center">

<img width="300" height="200" alt="스크린샷 2024-10-05 오후 4 11 15" src="https://github.com/user-attachments/assets/c5c31880-c650-487a-98fd-631aabebb4c3">
<img width="300" height="200" alt="스크린샷 2024-10-05 오후 4 12 19" src="https://github.com/user-attachments/assets/b591efa4-4d7a-484a-a0d4-408ce41c5a49">
</div>

<br>

- 원본 이미지를 단순히 resizable().frame(width:height:)으로 크기를 조절할 시 원본 이미지를 그대로 렌더링하므로 불필요하게 메모리가 많이 사용됨
- UIGraphicsImageRenderer를 사용해서 이미지 뷰가 필요로 하는 크기에 맞추어 리사이징하여 필요한 만큼만 픽셀 정보를 메모리에 로드시켜 메모리를 절약

<br>
<br>

### DI Container를 활용한 Clean Architecture + MVVM

> 영화 상세 정보 조회 기능에서의 Clean Architecture 활용 예시

<br>

<b> Data 계층 </b>

<image src="https://github.com/user-attachments/assets/da066701-9b3e-4e2a-ae5f-184c25fd32f7" width="800">


<br>
<br>

- DataSource 객체

  - 내/외부 데이터소스 작업 객체
  - NetworkManger와 같은 싱글톤 객체를 사용하기보다 기능 관련 리소스 단위를 더 명확하게 표현하고자 도입
 
- DefaultMovieContentRepository

  - async let을 사용하여 여러 개의 비동기 컨텍스트를 병렬적으로 처리
  - DataSource의 반환값을 Result 타입으로 할 경우 반복적인 switch문에 의해 불필요하게 코드 수가 늘어나는 것을 방지하기 위해 async throw와 try? 조합 사용

<br>

<b> Domain 계층 </b>
<br>

<image src="https://github.com/user-attachments/assets/a77a72a9-5fcc-4b78-af68-0b1d6e31c3ca" width="600" >
        
<br>
<br>

- 내/외부 Repository를 조합하여 완전한 Entity 데이터 생성
- ViewModel의 책임을 View와의 데이터 바인딩 역할로 제한하기 위해 UseCase 도입

<br>
<br>

<b> Presentation 계층 </b>
<br>

<image src="https://github.com/user-attachments/assets/4da112fe-8c3e-4cd3-893f-7678feae1f0a" width="600">

<br>
<br>

- Input으로는 PassThroughSubject, Output은 @Published를 활용하여 View와 데이터 바인딩
- Entity를 Presentation Model로 가공하여 View가 직접 Entity를 가공하지 않게 함


<br>
<b> DI Container </b>

<br>
<br>
<image src="https://github.com/user-attachments/assets/f770ee06-8f0b-41eb-9f71-2f044c8653a0" width = "700"">

<br>
<br>

- DI Container 도입 이유

  - ViewModel 객체를 하나 만들기 위해서 일일히 UseCase, Repository, DataSource 구현체를 생성하여 주입시키기 번거로움
  - 영화 상세 정보 화면의 경우 다른 영화 상세 정보 화면으로 넘어갈 수 있어 동일한 Resolve 체인이 반복적으로 생성될 수 있기 때문에 각각의 구현체 인스턴스를 단일로 유지하여 메모리적 이점을 가져가고자 하였음
 
- DI Container 활용 방법

  - MovieContentViewModel에서 UseCase를 주입받는 코드를 @Injected 프로퍼티 래퍼를 통해 추상화
  - 대부분의 구현체들은 단일로 유지되게 설정하였지만, 영화 검색 결과 화면에 사용되는 DataSource 구현체의 경우 Pagination 관련 상태값을 가지고 있기 때문에 매번 새로운 인스턴스를 생성되게 설정

<br>

