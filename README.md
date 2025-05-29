# SkillForge Academy

SkillForge Academy is a blockchain-based professional certification platform that provides verifiable skill credentials and connects instructors with learners through smart contracts.

## Features

- **Blockchain Certification**: Immutable professional skill certificates on Stacks
- **Instructor Monetization**: Direct payments for course completion
- **Skill Verification**: Transparent proof of professional competencies
- **Decentralized Learning**: Peer-to-peer education without intermediaries

## Smart Contract Functions

### Certification Management
- `issue-certificate`: Create new skill certification programs
- `complete-certification`: Complete a program and receive certification
- `get-certification-details`: View program information and requirements
- `get-certificate-holder`: Check who holds a specific certification
- `is-certified`: Verify if someone has completed a certification

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run `clarinet check` to verify contracts
4. Deploy using Clarinet or Stacks CLI

## For Instructors

Instructors can create certification programs by providing:
- Skill name and detailed curriculum
- Proof of completion requirements
- Completion fee in STX tokens

## For Students

Students can enroll and complete certifications, receiving blockchain-verified credentials upon successful completion.