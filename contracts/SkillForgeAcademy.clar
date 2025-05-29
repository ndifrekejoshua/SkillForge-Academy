;; SkillForge Academy - Professional certification and skill verification platform
(define-non-fungible-token skill-certificate uint)

;; Storage
(define-map certification-records uint {instructor: principal, skill-name: (string-utf8 64), curriculum: (string-utf8 256), proof-uri: (string-utf8 256), completion-fee: uint})
(define-data-var certificate-sequence uint u0)

;; Error codes
(define-constant err-access-denied (err u300))
(define-constant err-certificate-missing (err u301))
(define-constant err-insufficient-payment (err u302))
(define-constant err-blank-skill-name (err u303))
(define-constant err-blank-curriculum (err u304))
(define-constant err-invalid-proof (err u305))
(define-constant err-zero-fee (err u306))
(define-constant err-invalid-certificate (err u307))

;; Issue a new skill certificate
(define-public (issue-certificate (skill-name (string-utf8 64)) (curriculum (string-utf8 256)) (proof-uri (string-utf8 256)) (completion-fee uint))
  (begin
    ;; Validate certificate data
    (asserts! (> (len skill-name) u0) err-blank-skill-name)
    (asserts! (> (len curriculum) u0) err-blank-curriculum)
    (asserts! (> (len proof-uri) u0) err-invalid-proof)
    (asserts! (> completion-fee u0) err-zero-fee)
    
    (let
      ((cert-id (var-get certificate-sequence))
       (instructor tx-sender))
      
      ;; Mint certificate NFT
      (try! (nft-mint? skill-certificate cert-id instructor))
      
      ;; Record certification details
      (map-set certification-records cert-id {instructor: instructor, skill-name: skill-name, curriculum: curriculum, proof-uri: proof-uri, completion-fee: completion-fee})
      
      ;; Update sequence
      (var-set certificate-sequence (+ cert-id u1))
      
      (ok cert-id))))

;; Complete certification program
(define-public (complete-certification (cert-id uint))
  (begin
    ;; Validate certificate ID
    (asserts! (< cert-id (var-get certificate-sequence)) err-invalid-certificate)
    
    (let
      ((cert-data (unwrap! (map-get? certification-records cert-id) err-certificate-missing))
       (fee (get completion-fee cert-data))
       (instructor (get instructor cert-data))
       (current-holder (unwrap! (nft-get-owner? skill-certificate cert-id) err-certificate-missing)))
      
      ;; Verify student has sufficient funds
      (asserts! (>= (stx-get-balance tx-sender) fee) err-insufficient-payment)
      
      ;; Pay completion fee to instructor
      (try! (stx-transfer? fee tx-sender instructor))
      
      ;; Transfer certificate to student
      (try! (nft-transfer? skill-certificate cert-id current-holder tx-sender))
      
      (ok true))))

;; Get certification details
(define-read-only (get-certification-details (cert-id uint))
  (map-get? certification-records cert-id))

;; Check certificate holder
(define-read-only (is-certified (cert-id uint) (student principal))
  (is-eq (some student) (nft-get-owner? skill-certificate cert-id)))

;; Get certificate holder
(define-read-only (get-certificate-holder (cert-id uint))
  (nft-get-owner? skill-certificate cert-id))
