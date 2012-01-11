# encoding: utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2012 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

class App
  module Views
    class PersonDetail < Layout

      def title
        "#{name} - Berlin Racing Team"
      end

      def nav_team
        'active'
      end

      def person
        @person
      end

      def name
        person.name
      end

      def encrypted_email
        encrypt_email(person.email)
      end

      def participations?
        not person.participations.empty?
      end

      def person_participations
        year = participation_latest_year
        person.participations.map do |p|
          result = {
            title: "#{p.event.title}, #{p.event.distance} km",
            date: "#{p.event.date.day}. #{month_short(p.event.date)}",
            distance: p.event.distance,
            position_overall: p.position_overall,
            position_age_class: p.position_age_class
          }

          # year change
          if p.event.date.year < year
            # summary
            result['summary'] = participation_summary(year)
            year = p.event.date.year
            result['year'] = year
          end

          result
        end
      end

      def participation_summary(year)
        result = "#{person.participations_count(year)} Rennen"
        result << " mit #{person.events_distance(year)} km"
        top10 = person.participations_top10_count(year)
        result << " und einer Top10 Platzierung" if top10 == 1
        result << " und #{top10} Top10 Platzierungen" if top10 > 1
        result
      end

      def last_participation_summary
        participation_summary(last_participation.event.date.year)
      end

      def last_participation
        person.participations[-1]
      end

      def first_participation
        person.participations[0]
      end

      def participation_latest_year
        first_participation.date.year
      end

      def participations_top10?
        person.participations_top10_count > 0
      end

    end
  end
end



