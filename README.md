# Event Management System

A mobile-first Event Management System designed to streamline event planning, approvals, and coordination using a robust tech stack.

## Tech Stack
- **Frontend**: Flutter (cross-platform mobile UI)
- **Backend**: Node.js with Express (REST API)
- **Database**: MySQL (relational DBMS)

## Core Features
- **Role-Based Access**:
  - **Admin**: Approves/rejects events, manages logs and employees.
  - **Organizer**: Requests event creation.
  - **Coordinator**: Allocates venue, vendor, and transport.
  - **Support Staff**: Responds to user queries, handles promotions.
  - **Attendees**: Register for events, submit queries, provide feedback.

- **Event Workflow**:
  - Organizers submit event requests.
  - Admins review and approve them.
  - Coordinators allocate required resources.
  - Attendees can view and register for approved events.

- **Real-Time Logs**:
  - Tracks login, event actions, and role activities for security.

- **RESTful API**:
  - Node.js/Express backend handles all CRUD operations.

- **Modern UI**:
  - Flutter ensures smooth navigation and a visually appealing interface.

## Implementation Highlights
- Integrated MySQL with foreign key relationships.
- Full-stack testing: Unit, integration, UI/UX, and performance.
- Dynamic frontend using reusable Flutter components.
- Optimized backend APIs for fast data operations.

## Conclusion
The system provides a scalable, secure, and role-based solution for managing coding events. By automating workflows and improving accountability, it simplifies event planning for all stakeholders.
