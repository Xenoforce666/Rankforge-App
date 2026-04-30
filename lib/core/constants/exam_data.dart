import '../../models/exam_model.dart';

class ExamData {
  ExamData._();

  static const exams = <ExamModel>[
    ExamModel(
      id: 'upsc',
      title: 'UPSC',
      shortTitle: 'UPSC',
      description: 'Civil Services preparation with GS, optional basics, and current affairs.',
      dailyTargetHours: 6,
      baseTargetTasks: 5,
      subjects: [
        SubjectModel(
          id: 'polity',
          title: 'Indian Polity',
          topics: [
            TopicModel(id: 'constitution_basics', title: 'Constitutional framework'),
            TopicModel(id: 'fundamental_rights', title: 'Fundamental Rights and Duties'),
            TopicModel(id: 'parliament', title: 'Parliament and law making'),
            TopicModel(id: 'federalism', title: 'Federalism and center-state relations'),
            TopicModel(id: 'judiciary', title: 'Supreme Court and High Courts'),
          ],
        ),
        SubjectModel(
          id: 'history',
          title: 'History',
          topics: [
            TopicModel(id: 'ancient', title: 'Ancient India'),
            TopicModel(id: 'medieval', title: 'Medieval India'),
            TopicModel(id: 'modern', title: 'Modern India'),
            TopicModel(id: 'freedom', title: 'Freedom struggle'),
            TopicModel(id: 'world_history', title: 'World history overview'),
          ],
        ),
        SubjectModel(
          id: 'geography',
          title: 'Geography',
          topics: [
            TopicModel(id: 'physical', title: 'Physical geography'),
            TopicModel(id: 'indian', title: 'Indian geography'),
            TopicModel(id: 'resources', title: 'Resources and industries'),
            TopicModel(id: 'climate', title: 'Climate and monsoon'),
            TopicModel(id: 'mapping', title: 'Map practice'),
          ],
        ),
        SubjectModel(
          id: 'economy',
          title: 'Economy',
          topics: [
            TopicModel(id: 'national_income', title: 'National income'),
            TopicModel(id: 'banking', title: 'Banking and monetary policy'),
            TopicModel(id: 'fiscal', title: 'Budget and fiscal policy'),
            TopicModel(id: 'external', title: 'External sector'),
            TopicModel(id: 'schemes', title: 'Government schemes'),
          ],
        ),
        SubjectModel(
          id: 'environment',
          title: 'Environment',
          topics: [
            TopicModel(id: 'ecology', title: 'Ecology basics'),
            TopicModel(id: 'biodiversity', title: 'Biodiversity'),
            TopicModel(id: 'climate_change', title: 'Climate change'),
            TopicModel(id: 'pollution', title: 'Pollution control'),
            TopicModel(id: 'conventions', title: 'Environment conventions'),
          ],
        ),
      ],
    ),
    ExamModel(
      id: 'jpsc',
      title: 'JPSC',
      shortTitle: 'JPSC',
      description: 'Jharkhand state services preparation with state GK and GS coverage.',
      dailyTargetHours: 5,
      baseTargetTasks: 4,
      subjects: [
        SubjectModel(
          id: 'jharkhand_gk',
          title: 'Jharkhand GK',
          topics: [
            TopicModel(id: 'history', title: 'History of Jharkhand'),
            TopicModel(id: 'geography', title: 'Geography and resources'),
            TopicModel(id: 'tribal', title: 'Tribal society and culture'),
            TopicModel(id: 'economy', title: 'State economy'),
            TopicModel(id: 'current', title: 'Jharkhand current affairs'),
          ],
        ),
        SubjectModel(
          id: 'polity',
          title: 'Polity and Governance',
          topics: [
            TopicModel(id: 'constitution', title: 'Constitution basics'),
            TopicModel(id: 'panchayat', title: 'Panchayati Raj'),
            TopicModel(id: 'state_admin', title: 'State administration'),
            TopicModel(id: 'rights', title: 'Rights and duties'),
            TopicModel(id: 'welfare', title: 'Welfare schemes'),
          ],
        ),
        SubjectModel(
          id: 'general_studies',
          title: 'General Studies',
          topics: [
            TopicModel(id: 'history_india', title: 'Indian history'),
            TopicModel(id: 'geography_india', title: 'Indian geography'),
            TopicModel(id: 'economy_india', title: 'Indian economy'),
            TopicModel(id: 'science', title: 'General science'),
            TopicModel(id: 'environment', title: 'Environment'),
          ],
        ),
        SubjectModel(
          id: 'language',
          title: 'Language and Essay',
          topics: [
            TopicModel(id: 'hindi', title: 'Hindi grammar'),
            TopicModel(id: 'english', title: 'English comprehension'),
            TopicModel(id: 'essay', title: 'Essay practice'),
            TopicModel(id: 'precis', title: 'Precis writing'),
            TopicModel(id: 'translation', title: 'Translation practice'),
          ],
        ),
      ],
    ),
    ExamModel(
      id: 'rbi_grade_b',
      title: 'RBI Grade B',
      shortTitle: 'RBI',
      description: 'Phase 1 and Phase 2 preparation for RBI Grade B aspirants.',
      dailyTargetHours: 4,
      baseTargetTasks: 4,
      subjects: [
        SubjectModel(
          id: 'esi',
          title: 'Economic and Social Issues',
          topics: [
            TopicModel(id: 'growth', title: 'Growth and development'),
            TopicModel(id: 'poverty', title: 'Poverty and inclusion'),
            TopicModel(id: 'sustainable', title: 'Sustainable development'),
            TopicModel(id: 'social_sector', title: 'Social sector schemes'),
            TopicModel(id: 'reports', title: 'Reports and indices'),
          ],
        ),
        SubjectModel(
          id: 'finance',
          title: 'Finance',
          topics: [
            TopicModel(id: 'financial_system', title: 'Indian financial system'),
            TopicModel(id: 'markets', title: 'Financial markets'),
            TopicModel(id: 'risk', title: 'Risk management'),
            TopicModel(id: 'inflation', title: 'Inflation and monetary policy'),
            TopicModel(id: 'banking', title: 'Banking regulation'),
          ],
        ),
        SubjectModel(
          id: 'management',
          title: 'Management',
          topics: [
            TopicModel(id: 'leadership', title: 'Leadership'),
            TopicModel(id: 'motivation', title: 'Motivation theories'),
            TopicModel(id: 'communication', title: 'Communication'),
            TopicModel(id: 'ethics', title: 'Ethics at workplace'),
            TopicModel(id: 'hr', title: 'Human resource basics'),
          ],
        ),
        SubjectModel(
          id: 'phase_one',
          title: 'Phase 1 Aptitude',
          topics: [
            TopicModel(id: 'quant', title: 'Quantitative aptitude'),
            TopicModel(id: 'reasoning', title: 'Reasoning ability'),
            TopicModel(id: 'english', title: 'English language'),
            TopicModel(id: 'ga', title: 'General awareness'),
            TopicModel(id: 'mock_tests', title: 'Mock test analysis'),
          ],
        ),
      ],
    ),
  ];

  static ExamModel? byId(String? id) {
    if (id == null) {
      return null;
    }

    for (final exam in exams) {
      if (exam.id == id) {
        return exam;
      }
    }
    return null;
  }
}
